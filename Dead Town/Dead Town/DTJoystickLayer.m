//
//  DTJoystickLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTJoystickLayer.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "cocos2d.h"

@implementation DTJoystickLayer

-(void)setUpSneakyJoystick
{
    CGSize screen = [[CCDirector sharedDirector].winSize;
    SneakyJoystickSkinnedBase *joystick = [[SneakyJoystickSkinnedBase alloc] init];
    
}

-(void)setupSneakyFireButton
{
    CGSize screen = [[CCDirector sharedDirector].winSize;
    SneakyButtonSkinnedBase *fireButton = [[SneakyButtonSkinnedBase alloc] init];
    
}


@end
