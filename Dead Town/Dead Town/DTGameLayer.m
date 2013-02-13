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
        _floor = [_tileMap layerNamed:@"Floor"];
        _walls = [_tileMap layerNamed:@"Walls"];
        _walls.visible = YES; // Make sure no-one can see the transparent tiles!!!
        [self addChild:_tileMap];
        
        // Create the players
        _player = [DTPlayer initWithPlayerAtPoint:ccp(100, 100) parentLayer:self];
        [self addChild:_player];
        
        [self setViewpointCenter:_player.position]; // Center the map over the player
    }
    
    return self;
}

-(void)updatePlayerPositionForJoystick:(SneakyJoystick *)joystick andDelta:(float)delta
{
    CGPoint oldPosition = _player.sprite.position;
    CGPoint velocity = ccpMult(joystick.velocity, 140);
    CGPoint newPosition = ccp(oldPosition.x + velocity.x * delta,
                              oldPosition.y + velocity.y * delta);
    _player.sprite.position = newPosition;
    [self setViewpointCenter:newPosition];
}

-(void)setViewpointCenter:(CGPoint) position
{
    CGSize size = [CCDirector sharedDirector].winSize;
    int x = MAX(position.x, size.width / 2);
    int y = MAX(position.y, size.height / 2);
    x = MIN(x, (_tileMap.mapSize.width *_tileMap.tileSize.width) - size.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) - size.height/2);
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(size.width/2, size.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}

-(void)centerViewport:(CGPoint)position
{
    self.position = ccp(position.x, position.y);
}

@end
