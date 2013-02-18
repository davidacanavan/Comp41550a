//
//  DTGameLayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DTPlayer.h"
#import "SneakyJoystick.h"
#import "DTPausedLayer.h"
#import "DTOptions.h"

#define MIN_PLAYER_FIRE_GAP .1; // A fifth of a second

@class DTPlayer;
@class DTBullet;
@class DTControlsLayer;
@class DTPausedLayer;

@interface DTGameLayer : CCLayer
{
    @private
    CCTMXTiledMap *_tileMap;
    int _tileMapWidth;
    int _tileMapHeight;
    int _tileDimension;
    CCTMXLayer *_floor;
    CCTMXLayer *_walls;
    DTPlayer *_player;
    CGSize _screen;
    BOOL _isGameOver;
    float _currentPlayerFireGap;
    DTOptions *_options;
    DTPausedLayer *_pausedLayer;
}

@property(nonatomic) BOOL isFiring;
@property(nonatomic) BOOL isPausing;
@property(nonatomic, strong) DTControlsLayer *controlsLayer;

-(void)centerViewportOnPosition:(CGPoint)position;
-(void)updatePlayerPositionForJoystick:(SneakyJoystick *)joystick andDelta:(float)delta;
-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate;
-(CGPoint)tileCoordinateForPoint:(CGPoint)point;
-(void)unpause;
-(void)unpauseAll;

@end
