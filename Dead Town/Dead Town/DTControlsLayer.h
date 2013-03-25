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

@class DTGameLayer;
@class SneakyJoystick;
@class SneakyJoystickSkinnedBase;
@class SneakyButton;
@class SneakyButtonSkinnedBase;

typedef enum {LeftHanded, RightHanded} DominantHand;
typedef enum {Joystick, Tilt} ControllerType;

@interface DTControlsLayer : CCLayer <CCTargetedTouchDelegate, UIAccelerometerDelegate>
{
    @private
    // The map layer - this makes it easy to update the player position
    DTGameLayer *_gameLayer; 
    SneakyJoystickSkinnedBase *_joystickSkin;
    SneakyJoystick *_joystick;
    SneakyButton *_fireButton;
    SneakyButton *_pauseButton;
    CCDirector *_director;
    id <DTControllerDelegate> _controllerDelegate;
    CGSize _screen;
    float _lastAccelerometerTime;
    BOOL _wasTilting;
}

@property(nonatomic) BOOL isPausing;
@property(nonatomic) DominantHand dominantHand;
@property(nonatomic) ControllerType controllerType;

+(id)controlsLayerWithGameLayer:(DTGameLayer *)gameLayer controllerType:(ControllerType)controllerType controllerDelegate:(id <DTControllerDelegate>)controllerDelegate dominantHand:(DominantHand)dominantHand;

-(void)unpause;

@end












