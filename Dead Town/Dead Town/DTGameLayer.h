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
}

-(void)centerViewport:(CGPoint)position;
-(void)updatePlayerPositionForJoystick:(SneakyJoystick *)joystick andDelta:(float)delta;

@end
