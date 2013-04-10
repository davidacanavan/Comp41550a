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

@implementation DTLevel

+(id)levelWithTMXFile:(NSString *)tmxFile gameLayer:(DTGameLayer *)gameLayer;
{
    return [[self alloc] initWithTMXFile:tmxFile gameLayer:gameLayer];
}

-(id)initWithTMXFile:(NSString *)tmxFile gameLayer:(DTGameLayer *)gameLayer
{
    if (self = [super init])
    {
        // Save the DTGameLayer reference
        _gameLayer = gameLayer;
        
        // Get all the  map variables
        _map = [CCTMXTiledMap tiledMapWithTMXFile:tmxFile];
        _floor = [_map layerNamed:@"Floor"];
        _walls = [_map layerNamed:@"Walls"]; _walls.visible = YES;
        _spawns = [_map objectGroupNamed:@"Spawns"];
        
        // Get some layout dimensions
        _retinaFactor = CC_CONTENT_SCALE_FACTOR();
        _screen = [CCDirector sharedDirector].winSize;
        _tileMapWidth = _map.mapSize.width; // Measured in tiles!
        _tileMapHeight = _map.mapSize.height;
        _tileDimension = _map.tileSize.width / _retinaFactor; // Since they're square I don't need to look at the height - measured in pixels and scaled for retina!
        
        // Spawn the player at the start
        NSDictionary *player = [_spawns objectNamed:@"Player Spawn"];
        ccp([[player valueForKey:@"x"] floatValue] / _retinaFactor,
            [[player valueForKey:@"y"] floatValue] / _retinaFactor);
        [self onPlayerLoaded]; // Notify the subclass
    }
    
    return self;
}

-(NSMutableArray *)closestEnemiesToPlayer
{
    return nil;
}

-(void)centerViewportOnPosition:(CGPoint) position
{
    CGPoint centerOfView = ccp(_screen.width / 2, _screen.height / 2);
    _gameLayer.position = ccpSub(centerOfView, position);
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
    NSDictionary *dict = [_map propertiesForGID:gid];
    return [dict valueForKey:@"IsWall"] != nil;
}

-(BOOL)isTileOutOfBounds:(CGPoint)tileCoordinate
{
    return tileCoordinate.x < 0 || tileCoordinate.y < 0
        || tileCoordinate.x >= _tileMapWidth || tileCoordinate.y >= _tileMapHeight;
}

-(void)onPlayerLoaded {};

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


















