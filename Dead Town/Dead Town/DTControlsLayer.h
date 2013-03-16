//
//  DTJoystickLayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DTJoystickDelegate.h"

@class DTGameLayer;
@class SneakyJoystick;
@class SneakyJoystickSkinnedBase;
@class SneakyButton;
@class SneakyButtonSkinnedBase;

typedef enum {LeftHanded, RightHanded} DominantHand;

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
    id <DTJoystickDelegate> _joystickDelegate;
    CGSize _screen;
}

@property(nonatomic) BOOL isPausing;
@property(nonatomic) DominantHand dominantHand;

+(id)controlsLayerWithGameLayer:(DTGameLayer *)gameLayer useJoystick:(BOOL)useJoystick joystickDelegate:(id <DTJoystickDelegate>)joystickDelegate dominantHand:(DominantHand)dominantHand;
-(void)unpause;

@end












