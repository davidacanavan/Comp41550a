//
//  DTGameLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTGameLayer.h"
#import "DTBullet.h"
#import "SimpleAudioEngine.h"
#import "DTLifeModel.h"
#import "DTStatusLayer.h"
#import "DTHandGun.h"
#import "DTConstantDamageCalculator.h"
#import "DTLazerBeamNode.h"

@implementation DTGameLayer

@synthesize isPausing = _isPausing;
@synthesize controlsLayer = _controlsLayer;
@synthesize isHoldFiring = _isHoldFiring;

+(id)gameLayerWithStatusLayer:(DTStatusLayer *)statusLayer
{
    return [[self alloc] initWithStatusLayer:statusLayer];
}

-(id)initWithStatusLayer:(DTStatusLayer *)statusLayer
{
    if ((self = [super init]))
    {
        // Create the tile map and get the dimensions needed...
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"DTHospitalF1.tmx"];
        _tileMapWidth = _tileMap.mapSize.width; // Measured in tiles!
        _tileMapHeight = _tileMap.mapSize.height;
        _tileDimension = _tileMap.tileSize.width / CC_CONTENT_SCALE_FACTOR(); // Since they're square this is ok - measured in pixels and scaled for retina!
        _floor = [_tileMap layerNamed:@"Floor"];
        _walls = [_tileMap layerNamed:@"Walls"];
        _walls.visible = YES; // Make sure no-one can see the transparent tiles!!!
        [self addChild:_tileMap];
        _statusLayer = statusLayer;
        
        // Create the players TODO: second player!!!
        _player = [DTPlayer playerAtPosition:ccp(100, 100) gameLayer:self life:100];
        _player.weapon = [DTHandGun weapon];
        [_player.lifeModel addDelegate: (id <DTLifeModelDelegate>) _statusLayer.lifeNode]; // TODO: Do I have to cast this?
        [self addChild:_player];
        

        // TEST CODE!!!!
        _zombie = [DTStraightLineZombie zombieWithPlayer:_player runningDistance:250 gameLayer:self position:ccp(150, 400) life:100];
        [self addChild:_zombie];
        
        DTLazerBeamNode *lazer = [DTLazerBeamNode nodeWithOrigin:_player];
        lazer.target = _zombie;
        [self addChild: lazer];
        
        // Get some other variables we'll need
        _screen = [CCDirector sharedDirector].winSize;
        
        // Center the map over the player TODO: Add a spawn point for the players on the map
        [self centerViewportOnPosition:[_player getPosition]];
        
        _isGameOver = NO;
        _options = [DTOptions sharedOptions];
        
        [self unpause];
    }
    
    return self;
}

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

-(void)centerViewportOnPosition:(CGPoint) position
{
    CGPoint centerOfView = ccp(_screen.width / 2, _screen.height / 2);
    self.position = ccpSub(centerOfView, position);
}

// Converts the layer point to a tile coordinate (they go from top left)
-(CGPoint)tileCoordinateForPosition:(CGPoint)point
{
    // So if the x or y are beyond the screen bounds then fix them to -1 as an off limit coordinate, otherwise we just adjust to normal
    int x = (point.x < 0) ? -1 : point.x / _tileDimension;
    int mapDimensionInPoints = _tileMapHeight * _tileDimension;
    int y = (point.y > mapDimensionInPoints) ? -1 : (mapDimensionInPoints - point.y) / _tileDimension;
    return ccp(x, y);
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
    NSDictionary *dict = [_tileMap propertiesForGID:gid];
    return [dict valueForKey:@"IsWall"] != nil;
}

-(BOOL)isTileOutOfBounds:(CGPoint)tileCoordinate
{
    return tileCoordinate.x < 0 || tileCoordinate.y < 0 || tileCoordinate.x >= _tileMapWidth || tileCoordinate.y >= _tileMapHeight; // TODO: Check the top end as well!
}

-(DTCharacter *)closestEnemyToCharacter:(DTCharacter *)player
{
    return _zombie;
}

-(void)gameOver
{
    
}

-(void)pause
{
    _isPausing = NO;
    [self unschedule:@selector(gameLoopUpdate:)];
    _pausedLayer = [DTPausedLayer pausedLayerWithGameLayer:self andControlsLayer:_controlsLayer];
    [[self parent] addChild:_pausedLayer z:1];
    
    if (_options.playBackgroundMusic)
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void)unpause
{
    // Schedule the tick so we can check for pausing and gameover
    [self schedule:@selector(gameLoopUpdate:)];
    
    if (_options.playBackgroundMusic)
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BackingTrack.m4a" loop:YES];
    
}

-(void)unpauseAll
{
    [self unpause];
    [_controlsLayer unpause];
}

-(void)gameLoopUpdate:(float)delta
{
    if (_isGameOver) // So check for the game over condition and end if it's all done
    {
        [self gameOver];
        return;
    }
    
    if (_isPausing) // Check for a pause request
    {
        [self pause];
        return;
    }
    
    if (_isHoldFiring)
        [_player fire]; // So let him fire
}

#pragma mark-
#pragma mark Button delegate implementation
-(void)buttonPressed:(DTButton *)button
{
    [_player fire];
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

@end









