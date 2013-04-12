//
//  DTLevel.m
//  Dead Town
//
//  Created by David Canavan on 29/03/2013.
//
//

#import "DTLevel.h"
#import "DTCharacter.h"
#import "DTGameLayer.h"
#import "DTHandGun.h"
#import "DTStraightLineZombie.h"
#import "DTLazerBeamNode.h"
#import "DTPlayer.h"
#import "DTLifeModelDelegate.h"
#import "DTStatusLayer.h"
#import "DTLifeModel.h"
#import "DTButton.h"
#import "DTTrigger.h"
#import "DTPathFindZombie.h"

@implementation DTLevel

@synthesize gameLayer = _gameLayer;
@synthesize player = _player;

+(id)levelWithTMXFile:(NSString *)tmxFile;
{
    return [[self alloc] initWithTMXFile:tmxFile];
}

-(id)initWithTMXFile:(NSString *)tmxFile
{
    if (self = [super init])
    {
        // Get all the  map variables
        _map = [CCTMXTiledMap tiledMapWithTMXFile:tmxFile];
        
        //for (CCTMXLayer *child in _map.children)
            //[[child texture] setAliasTexParameters];
        
        _floor = [_map layerNamed:@"Floor"];
        _walls = [_map layerNamed:@"Walls"];
        _spawnObjects = [_map objectGroupNamed:@"Spawns"];
        _triggerObjects = [_map objectGroupNamed:@"Triggers"];
        _walls.visible = NO; // Make sure no-one can see the transparent tiles!!!
        
        // Get some layout dimensions
        _retinaFactor = CC_CONTENT_SCALE_FACTOR();
        _screen = [CCDirector sharedDirector].winSize;
        _tileMapWidth = _map.mapSize.width; // Measured in tiles!
        _tileMapHeight = _map.mapSize.height;
        _tileDimension = _map.tileSize.width / _retinaFactor; // Since they're square I don't need to look at the height - measured in pixels and scaled for retina!
        _spawnCheckInterval = .2;
        _spawnCheckTime = 0;
    }
    
    return self;
}

#pragma mark-
#pragma mark TileMap Functions

-(void)centerViewportOnPosition:(CGPoint) position
{
    CGPoint centerOfView = ccp(_screen.width / 2, _screen.height / 2);
    CGPoint newPosition = ccpSub(centerOfView, position);
    _gameLayer.position = ccp((int) newPosition.x, (int) newPosition.y); // Cast to int to prevent artifacts
}

// Converts the layer point to a tile coordinate (they go from top left)
-(CGPoint)tileCoordinateForPosition:(CGPoint)point
{
    // So if the x or y are beyond the screen bounds then fix them to -1 as an off limit coordinate, otherwise we just adjust to normal TODO: why do i do this again?
    int x = (point.x < 0) ? -1 : point.x / _tileDimension;
    int mapDimensionInPoints = _tileMapHeight * _tileDimension;
    int y = (point.y > mapDimensionInPoints) ? -1 : (mapDimensionInPoints - point.y) / _tileDimension;
    return ccp(x, y);
}

-(CGPoint)positionForTileCoordinate:(CGPoint)tileCoordinate
{ // Add half to centre the coordinate in the tile
    return ccp(tileCoordinate.x * _tileDimension + _tileDimension / 2,
               _tileDimension * _tileMapHeight - (tileCoordinate.y * _tileDimension) + _tileDimension / 2);
}

-(BOOL)isWallAtPosition:(CGPoint)position
{
    return [self isWallAtTileCoordinate:[self tileCoordinateForPosition:position]];
}

-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate
{
    // Check the edge of the map and pretend that an out of bounds tile is a wall
    if ([self isTileOutOfBounds:tileCoordinate])
        return YES;
    
    // Here I check the actual tile to see if it's a wall or not
    int gid = [_walls tileGIDAt:tileCoordinate];
    NSDictionary *dict = [_map propertiesForGID:gid];
    return [dict valueForKey:@"IsWall"] != nil;
}

-(BOOL)isTileOutOfBounds:(CGPoint)tileCoordinate
{
    return tileCoordinate.x < 0 || tileCoordinate.y < 0
        || tileCoordinate.x >= _tileMapWidth || tileCoordinate.y >= _tileMapHeight;
}

-(CGRect)createRectFromSpawn:(NSDictionary *)spawn
{
    return CGRectMake(
        [[spawn valueForKey:@"x"] floatValue] / _retinaFactor,
        [[spawn valueForKey:@"y"] floatValue] / _retinaFactor,
        [[spawn valueForKey:@"width"] floatValue] / _retinaFactor,
        [[spawn valueForKey:@"height"] floatValue] / _retinaFactor);
}

-(CGPoint)createRectCentreFromSpawn:(NSDictionary *)spawn
{
    return [self centreOfRect:[self createRectFromSpawn:spawn]];
}

-(CGPoint)centreOfRect:(CGRect)rect
{
    return ccp(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

#pragma mark-
#pragma mark Joystick Delegate

// Called by the controls layer when the joystick is moved
-(void)controllerUpdated:(CGPoint)cvelocity delta:(float)delta
{
    CGPoint oldPosition = [_player getPosition];
    CGPoint velocity = ccpMult(cvelocity, 140);
    CGPoint newPosition = ccp(oldPosition.x + velocity.x * delta,
                              oldPosition.y + velocity.y * delta);
    
    if (_isHoldFiring) // In this case we don't move the player at all, but we still change which way he's facing
    {
        [_player turnToFacePosition:newPosition]; // Tell him where to look
        return;
    }
    
    [_player turnToFacePosition:newPosition]; // Tell him where to look
    
    if (![self isWallAtPosition:newPosition])
    {
        [_player moveToPosition:newPosition]; // Update the player position
        [self centerViewportOnPosition:newPosition];
    }
    
}

-(void)controllerMoveStarted
{
    _joystickActive = YES;
    // So he's only moving as long as he's not hold firing! This has to be put in in case the user is hold-firing before he starts to run
    if (!_isHoldFiring)
        [_player notifyMovementStart];
}

-(void)controllerMoveEnded
{
    _joystickActive = NO;
    if (!_isHoldFiring)
        [_player notifyMovementEnd];
}

#pragma mark-
#pragma mark Button Delegate

-(void)buttonPressed:(DTButton *)button
{
    if ([button.tag isEqualToString:@"fire"])
        [_player fire];
    else
        _gameLayer.isPausing = YES; // TODO: Do the pausing better!!!
}

-(void)buttonHoldStarted:(DTButton *)button
{
    _isHoldFiring = YES;
}

-(void)buttonHoldContinued:(DTButton *)button
{
    [_player notifyMovementEnd]; // So if the user is running we just tell him not to run anymore if a hold fire occurs
}

-(void)buttonHoldEnded:(DTButton *)button
{
    if (_joystickActive)
        [_player notifyMovementStart];
    
    _isHoldFiring = NO;
}

#pragma mark-
#pragma mark LifeModel Delegate

-(void)lifeChangedFrom:(float)oldLife model:(DTLifeModel *)lifeModel character:(DTCharacter *)character
{
    if (character.characterType == CharacterTypeVillian && [lifeModel isZero])
    {
        [_villains removeObject: character]; // TODO: This could be faster
        [self onVillainKilled:character];
        [self removeChild:character cleanup:NO];
    }// TODO: Something similar for our hero
}

#pragma mark-
#pragma mark Subclass Overridables

-(void)onPlayerLoaded {}
-(void)onVillainKilled:(DTCharacter *)character {}
-(void)onTriggerEncountered:(DTTrigger *)trigger {}
-(void)onSpawnPointEncountered {}

#pragma mark-
#pragma mark Property Overrides

-(void)setGameLayer:(DTGameLayer *)gameLayer
{
    // Save the DTGameLayer reference
    _gameLayer = gameLayer;
    [_gameLayer addChild:_map];
    
    // Create the players TODO: second player!!!
    CGPoint playerPosition = [self createRectCentreFromSpawn:[_spawnObjects objectNamed:@"Player Spawn 0"]];
    _player = [DTPlayer playerWithLevel:self position:playerPosition life:100];
    _player.weapon = [DTHandGun weapon];
    [_player.lifeModel addDelegate: (id <DTLifeModelDelegate>) _gameLayer.statusLayer.lifeNode]; // TODO: Do I have to cast this?
    [self addChild:_player];
    
    // Get all the trigger rects and save them
    NSMutableArray *triggerDicts = [_triggerObjects objects];
    _triggers = [NSMutableArray arrayWithCapacity:[triggerDicts count]];
    
    // Save the triggers we have here for later
    for (NSDictionary *dict in triggerDicts)
    {
        [_triggers addObject:[DTTrigger triggerWithName:[dict objectForKey:@"name"]
                andRect:[self createRectFromSpawn:dict]]];
    }
    
    _villains = [NSMutableArray arrayWithCapacity:20];
    
    [self centerViewportOnPosition:[_player getPosition]]; // Center over the player
    [self onPlayerLoaded]; // Notify the subclass
    
    //DTLazerBeamNode *lazer = [DTLazerBeamNode nodeWithOrigin:_player];
    //lazer.target = zombie;
    //[self addChild: lazer];
    
    [_gameLayer addChild:self]; // Just so we can get the update
    [self scheduleUpdate];
}

#pragma mark-
#pragma mark Game Updates

-(void)update:(ccTime)delta
{
    if (_isHoldFiring)
        [_player fire]; // So let him fire
    
    _spawnCheckTime += delta;
    
    if (_spawnCheckTime >= _spawnCheckInterval)
    {
        [self checkForTriggers];
        _spawnCheckTime = 0;
    }
}

-(void)checkForTriggers
{
    DTTrigger *triggerToBeRemoved = nil; // TODO: This assumes only one trigger is hit at a time, pretty reasonable me thinks
    
    for (DTTrigger *trigger in _triggers)
    {
        if (CGRectIntersectsRect(_player.sprite.boundingBox, trigger.rect))
        {
            NSDictionary *triggerVariables = [_triggerObjects objectNamed:trigger.name];
            NSDictionary *spawnDict = [_spawnObjects objectNamed:[NSString stringWithFormat:@"ES%@", [triggerVariables objectForKey:@"ES"]]];
            CGPoint spawnPoint = [self createRectCentreFromSpawn:spawnDict];
            //DTStraightLineZombie *zombie = [DTStraightLineZombie zombieWithLevel:self position:spawnPoint
                //life:100 velocity:120 player:_player runningDistance:250];
            DTPathFindZombie *zombie = [DTPathFindZombie zombieWithLevel:self position:spawnPoint life:100 velocity:50 player:_player];
            [_villains addObject:zombie];
            [zombie.lifeModel addDelegate:self];
            [self addChild:zombie];
            triggerToBeRemoved = trigger; // Prevent lots of them coming along
        }
    }
    
    if (triggerToBeRemoved)
        [_triggers removeObject:triggerToBeRemoved];
}

#pragma mark-
#pragma mark GameLayer Shortcuts

// We wont actually add to this, but since the game thinks this is the game layer it decouples the classes a bit
-(void)addChild:(CCNode *)node
{
    [_gameLayer addChild:node];
}

-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup
{
    [_gameLayer removeChild:node cleanup:cleanup];
}

#pragma mark-

-(void)addVillain:(DTCharacter *)villain
{
    [_villains addObject:villain];
}

@end


















