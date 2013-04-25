//
//  DTGameLayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "DTPlayer.h"
#import "SneakyJoystick.h"
#import "DTPausedLayer.h"
#import "DTOptions.h"
#import "DTControllerDelegate.h"
#import "DTButtonDelegate.h"

@class DTPlayer;
@class DTBullet;
@class DTControlsLayer;
@class DTPausedLayer;
@class DTStraightLineZombie;
@class DTStatusLayer;

@interface DTGameLayer : CCLayer
{
    @private
    DTOptions *_options;
    DTPausedLayer *_pausedLayer;
    DTStraightLineZombie *_zombie;
}

@property(nonatomic, strong) DTControlsLayer *controlsLayer;
@property(nonatomic, strong) DTStatusLayer *statusLayer;

+(id)gameLayerWithStatusLayer:(DTStatusLayer *)statusLayer;

@end




