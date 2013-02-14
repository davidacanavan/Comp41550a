//
//  DTGameLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTGameLayer.h"

@implementation DTGameLayer

-(id)init
{
    if ((self = [super init]))
    {
        // Create the tile map...
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"DTHospitalF1.tmx"];
        _tileMapWidth = _tileMap.mapSize.width;
        _tileMapHeight = _tileMap.mapSize.height;
        _tileDimension = _tileMap.tileSize.width / CC_CONTENT_SCALE_FACTOR(); // Since they're square this is ok
        _floor = [_tileMap layerNamed:@"Floor"];
        _walls = [_tileMap layerNamed:@"Walls"];
        _walls.visible = YES; // Make sure no-one can see the transparent tiles!!!
        [self addChild:_tileMap];
        
        // Create the players
        _player = [DTPlayer initWithPlayerAtPoint:ccp(100, 100) parentLayer:self];
        [self addChild:_player];
        
        // Get some other variables we'll need
        _screen = [CCDirector sharedDirector].winSize;
        
        // Center the map over the player
        [self centerViewportOnPosition:_player.position];
    }
    
    return self;
}

-(void)updatePlayerPositionForJoystick:(SneakyJoystick *)joystick andDelta:(float)delta
{
    CGPoint oldPosition = _player.sprite.position;
    CGPoint tileCoordinate = [self tileCoordinateForPoint:oldPosition];
    
    if ([self isWallAtTileCoordinate:tileCoordinate])
    {
        [_player movePlayerToPoint: [_player previousPosition]]; // TODO: this stops the player getting stuck but it warbles a bit!
        return;
    }
    
    CGPoint velocity = ccpMult(joystick.velocity, 140);
    CGPoint newPosition = ccp(oldPosition.x + velocity.x * delta,
                              oldPosition.y + velocity.y * delta);
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
-(CGPoint)tileCoordinateForPoint:(CGPoint)point
{
    int x = point.x / _tileDimension;
    int y = (_tileMapHeight * _tileDimension - point.y) / _tileDimension;
    return ccp(x, y);
}

-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate
{
    int gid = [_walls tileGIDAt:tileCoordinate];
    NSDictionary *dict = [_tileMap propertiesForGID:gid];
    return [dict valueForKey:@"IsWall"] != nil;
}



@end









