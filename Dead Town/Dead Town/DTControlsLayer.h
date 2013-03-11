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
#import "DTControlsListener.h"

@class DTGameLayer;

@interface DTControlsLayer : CCLayer <CCTargetedTouchDelegate>
{
    @private
    // The map layer - this makes it easy to update the player position
    DTGameLayer *_gameLayer; 
    SneakyJoystickSkinnedBase *_joystickSkin;
    SneakyJoystick *_joystick;
    SneakyButton *_fireButton;
    SneakyButton *_pauseButton;
    CCDirector *_director;
    id <DTControlsListener> _controlsListener;
    CGSize _screen;
    float _qualifyingTimeForHold;
    float _currentHoldTime;
    BOOL _isPossibleHold;
    BOOL _isJoystickActive;
}

@property(nonatomic) BOOL isPausing;

+(id)controlsLayerWithGameLayer:(DTGameLayer *)gameLayer useJoystick:(BOOL)useJoystick controlsListener:(id <DTControlsListener>)controlsListener;
-(void)unpause;

@end












