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

@class DTGameLayer;
@class SneakyJoystick;
@class SneakyJoystickSkinnedBase;
@class SneakyButton;
@class SneakyButtonSkinnedBase;

typedef enum {DominantHandLeft, DominantHandRight} DominantHand;
typedef enum {ControllerTypeJoystick, ControllerTypeTilt} ControllerType;

@interface DTControlsLayer : CCLayer <CCTargetedTouchDelegate, UIAccelerometerDelegate>
{
    @private
    // The map layer - this makes it easy to update the player position
    SneakyJoystickSkinnedBase *_joystickSkin;
    SneakyJoystick *_joystick;
    CCDirector *_director;
    id <DTControllerDelegate> _controllerDelegate;
    id <DTButtonDelegate> _buttonDelegate;
    CGSize _screen;
    float _lastAccelerometerTime;
    BOOL _wasTilting;
    CGPoint _tiltControlVelocity;
}

@property(nonatomic) BOOL isPausing;
@property(nonatomic) DominantHand dominantHand;
@property(nonatomic) ControllerType controllerType;
@property(nonatomic, readonly) DTButton *fireButton, *pauseButton;

+(id)layerWithControllerType:(ControllerType)controllerType controllerDelegate:(id <DTControllerDelegate>)controllerDelegate buttonDelegate:(id <DTButtonDelegate>)buttonDelegate dominantHand:(DominantHand)dominantHand;

-(void)pause;
-(void)unpause;

@end












