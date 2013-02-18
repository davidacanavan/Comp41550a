//
//  DTJoystickLayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"
#import "DTGameLayer.h"

@class DTGameLayer;

@interface DTControlsLayer : CCLayer <CCTargetedTouchDelegate>
{
    @private
    // The map layer - this makes it easy to update the player position
    DTGameLayer *_gameLayer; // TODO: should i pass this stuff through the scene instead?
    SneakyJoystickSkinnedBase *_joystickSkin;
    SneakyJoystick *_joystick;
    SneakyButton *_fireButton;
    SneakyButton *_pauseButton;
    CCDirector *_director;
    CGSize _screen;
}

@property(nonatomic) BOOL isPausing;

+(id)controlsLayerWithGameLayer:(DTGameLayer *)gameLayer;
-(void)unpause;

@end
