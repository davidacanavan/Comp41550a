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
#import "DTGameLayer.h"

@interface DTControlsLayer : CCLayer
{
    @private
    // The map layer - this makes it easy to update the player position
    DTGameLayer *_gameLayer; // TODO: should i pass this stuff through the scene instead?
    SneakyJoystick *_joystick;
    SneakyButton *_fireButton;
    CGSize _screen;
}

+(id)initWithGameLayer:(DTGameLayer *)gameLayer;

@end
