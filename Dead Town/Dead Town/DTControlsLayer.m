//
//  DTJoystickLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTControlsLayer.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"

@implementation DTControlsLayer

-(id)init
{
    if ((self = [super init]))
    {
        [self setUpSneakyJoystick];
        [self setupSneakyFireButton];
    }
    
    return self;
}

// Create the joystick and add it to the layer
-(void)setUpSneakyJoystick
{
    SneakyJoystickSkinnedBase *joystick = [[SneakyJoystickSkinnedBase alloc] init];
    joystick.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 0, 255) radius:36];
    joystick.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 100, 255) radius:12];
    CGSize joystickSize = joystick.contentSize;
    joystick.position = ccp(15 + joystickSize.width / 2, 15 + joystickSize.height / 2);
    [self addChild:joystick];
}

// Create the shoot button and add it to the layer
-(void)setupSneakyFireButton
{
    CGSize screen = [CCDirector sharedDirector].winSize;
    SneakyButtonSkinnedBase *fireButton = [[SneakyButtonSkinnedBase alloc] init];
    fireButton.defaultSprite = [ColoredCircleSprite circleWithColor: ccc4(255, 255, 0, 255)radius:24];
    CGSize fireButtonSize = fireButton.contentSize;
    fireButton.position = ccp(screen.width - 15 - fireButtonSize.width / 2, 15 + fireButtonSize.height / 2);
    [self addChild:fireButton];
}


@end
