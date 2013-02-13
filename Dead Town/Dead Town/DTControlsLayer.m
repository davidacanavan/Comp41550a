//
//  DTJoystickLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTControlsLayer.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"
#import "ColoredCircleSprite.h"

@implementation DTControlsLayer

+(id)initWithGameLayer:(DTGameLayer *)gameLayer
{
    return [[self alloc] initWithGameLayer:gameLayer];
}

-(id)initWithGameLayer:(DTGameLayer *)gameLayer
{
    if ((self = [super init]))
    {
        [self setUpSneakyJoystick];
        [self setupSneakyFireButton];
        [self schedule:@selector(tick:)];
        _gameLayer = gameLayer;
        _screen = [CCDirector sharedDirector].winSize;
    }
    
    return self;
}

-(void)tick:(float)delta
{
    if (!CGPointEqualToPoint(_joystick.stickPosition, CGPointZero)) // So we're moving the character a little bit - so tell the game layer to move him!
    {
        [_gameLayer updatePlayerPositionForJoystick:_joystick andDelta:delta];
    }
}

// Create the joystick and add it to the layer
-(void)setUpSneakyJoystick
{
    // Some variables to get the sizes of the controls
    int padding = 15, joystickRadius = 36, joystickThumbRadius = joystickRadius / 3;
    
    // Create the joystick skin from plain old dots
    SneakyJoystickSkinnedBase *joystickSkin = [[SneakyJoystickSkinnedBase alloc] init];
    joystickSkin.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 0, 120) radius:joystickRadius];
    joystickSkin.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 100, 255) radius:joystickThumbRadius];
    CGSize joystickSize = joystickSkin.contentSize;
    joystickSkin.position = ccp(padding + joystickSize.width / 2, padding + joystickSize.height / 2);
    _joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, joystickRadius * 2, joystickRadius * 2)];
    joystickSkin.joystick = _joystick;
    [self addChild:joystickSkin];
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
