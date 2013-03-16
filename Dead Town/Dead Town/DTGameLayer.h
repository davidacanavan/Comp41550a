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
#import "DTStraightLineZombie.h"
#import "DTJoystickDelegate.h"
#import "DTSneakyButtonDelegate.h"

#define MIN_PLAYER_FIRE_GAP .1; // A fifth of a second

@class DTPlayer;
@class DTBullet;
@class DTControlsLayer;
@class DTPausedLayer;
@class DTStraightLineZombie;

@interface DTGameLayer : CCLayer <DTJoystickDelegate, DTSneakyButtonDelegate>
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
    int _holdNumber;
    BOOL _joystickActive;
}

@property(nonatomic) BOOL isFiring; // Set to true if the user is firing
@property(nonatomic) BOOL isHoldFiring; // Set to true if the user is firing and holding the button
@property(nonatomic) BOOL isPausing; // Set to true to pause the game layer and all children
@property(nonatomic, strong) DTControlsLayer *controlsLayer;

-(void)centerViewportOnPosition:(CGPoint)position;
-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate;
-(BOOL)isWallAtPosition:(CGPoint)position;
-(CGPoint)tileCoordinateForPosition:(CGPoint)point;
-(void)unpause;
-(void)unpauseAll;

@end
