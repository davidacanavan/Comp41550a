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

@implementation DTGameLayer

@synthesize isFiring = _isFiring;
@synthesize isPausing = _isPausing;
@synthesize controlsLayer = _controlsLayer;

-(id)init
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
        
        // Create the players TODO: second player!!!
        _player = [DTPlayer playerWithPlayerAtPoint:ccp(100, 100) withGameLayer:self];
        [self addChild:_player];
        
        // TEST CODE!!!!
        DTStraightLineZombie *zombie = [DTStraightLineZombie zombieWithPlayer:_player andRunningDistance:250 withGameLayer:self andPosition:ccp(150, 400)];
        [self addChild:zombie];
        
        // Get some other variables we'll need
        _screen = [CCDirector sharedDirector].winSize;
        
        // Center the map over the player TODO: Add a spawn point for the players on the map
        [self centerViewportOnPosition:_player.position];
        
        _isGameOver = NO;
        _isFiring = NO;
        _currentPlayerFireGap = MIN_PLAYER_FIRE_GAP; // Set the player to have not been firing at all
        _options = [DTOptions sharedOptions];
        
        [self unpause];
    }
    
    return self;
}

// Called by the controls layer when the joystick is moved
-(void)updatePlayerPositionForJoystick:(SneakyJoystick *)joystick andDelta:(float)delta
{
    CGPoint oldPosition = _player.sprite.position;
    CGPoint tileCoordinate = [self tileCoordinateForPosition:oldPosition];
    
    if ([self isWallAtTileCoordinate:tileCoordinate])
    {
        [_player movePlayerToPoint: [_player previousPosition]]; // TODO: this stops the player getting stuck but it warbles a bit!
        return;
    }
    
    CGPoint velocity = ccpMult(joystick.velocity, 140);
    CGPoint newPosition = ccp(oldPosition.x + velocity.x * delta,
                              oldPosition.y + velocity.y * delta);
    [_player turnToFacePoint:newPosition]; // Tell him where to look
    [_player movePlayerToPoint:newPosition]; // Update the player position
    [self centerViewportOnPosition:newPosition];
}

-(void)centerViewportOnPosition:(CGPoint) position
{
    int x = MAX(position.x, _screen.width / 2);
    int y = MAX(position.y, _screen.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) - _screen.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) - _screen.height/2);
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(_screen.width / 2, _screen.height / 2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
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

-(void)gameOver
{
    
}

-(void)pause
{
    _isPausing = NO;
    [self unschedule:@selector(tick:)];
    _pausedLayer = [DTPausedLayer pausedLayerWithGameLayer:self andControlsLayer:_controlsLayer];
    [[self parent] addChild:_pausedLayer z:1];
    
    if (_options.playBackgroundMusic)
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void)unpause
{
    // Schedule the tick so we can check for pausing and gameover
    [self schedule:@selector(tick:)];
    
    if (_options.playBackgroundMusic)
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BackingTrack.m4a" loop:YES];
    
}

-(void)unpauseAll
{
    [self unpause];
    [_controlsLayer unpause];
}

-(void)tick:(float)delta
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
    
    // So I use this variable to control how often the player can fire.
    float minPlayerFireGap = MIN_PLAYER_FIRE_GAP; // _currentPlayerFireGap is set to MIN_PLAYER.. initially
    _currentPlayerFireGap = MIN(minPlayerFireGap, _currentPlayerFireGap + delta);
    
    // So when it hits the minimum gap and the user wants to fire I allow it
    if (_isFiring && _currentPlayerFireGap == minPlayerFireGap)
    {
        [_player fire]; // So let him fire
        _isFiring = NO; // He's not firing anymore!
        _currentPlayerFireGap = 0; // Put this to 0 so he can't fire for the MIN gap
    }
}


@end









