//
//  DTJoystickLayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DTControllerDelegate.h"
#import "DTButtonDelegate.h"
#import "DTGuiTypes.h"

@class DTGameLayer;
@class SneakyJoystick;
@class SneakyJoystickSkinnedBase;
@class SneakyButton;
@class SneakyButtonSkinnedBase;

@interface DTControlsLayer : CCLayer <CCTargetedTouchDelegate, UIAccelerometerDelegate>
{
    @private
    // Sneaky API stuff
    SneakyJoystickSkinnedBase *_joystickSkin;
    SneakyJoystick *_joystick;
    SneakyButtonSkinnedBase *_fireButtonSkin, *_pauseButtonSkin;
    
    CCDirector *_director;
    id <DTControllerDelegate> _controllerDelegate;
    id <DTButtonDelegate> _buttonDelegate;
    CGSize _screen;
    
    // Accelerometer controls
    float _lastAccelerometerTime;
    BOOL _wasTilting;
    CGPoint _tiltControlVelocity;
}

@property(nonatomic) BOOL isPausing;
@property(nonatomic) DTDominantHand dominantHand;
@property(nonatomic) DTControllerType controllerType;
@property(nonatomic, readonly) DTButton *fireButton, *pauseButton;

+(id)layerWithControllerType:(DTControllerType)controllerType controllerDelegate:(id <DTControllerDelegate>)controllerDelegate buttonDelegate:(id <DTButtonDelegate>)buttonDelegate dominantHand:(DTDominantHand)dominantHand;

@end












