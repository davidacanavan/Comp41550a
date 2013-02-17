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

+(id)controlsLayerWithGameLayer:(DTGameLayer *)gameLayer
{
    return [[self alloc] initWithGameLayer:gameLayer];
}

-(id)initWithGameLayer:(DTGameLayer *)gameLayer
{
    if ((self = [super init]))
    {
        // Save some local variables
        _gameLayer = gameLayer;
        _screen = [CCDirector sharedDirector].winSize;
        
        [self setUpSneakyJoystick];
        [self setUpSneakyFireButton];
        [self setUpSneakyPauseButton];
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

-(void)tick:(float)delta
{
    // So we're moving the character a little bit - so tell the game layer to move him!
    if (!CGPointEqualToPoint(_joystick.stickPosition, CGPointZero)) 
        [_gameLayer updatePlayerPositionForJoystick:_joystick andDelta:delta];
    
    // Check to see if we're firing a bullet
    if (_fireButton.active)
        _gameLayer.isFiring = YES;
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
-(void)setUpSneakyFireButton
{
    int padding = 15, buttonRadius = 24;
    SneakyButtonSkinnedBase *fireButtonSkin = [[SneakyButtonSkinnedBase alloc] init];
    fireButtonSkin.defaultSprite = [ColoredCircleSprite circleWithColor: ccc4(255, 255, 0, 255)radius:buttonRadius];
    CGSize fireButtonSize = fireButtonSkin.contentSize;
    fireButtonSkin.position = ccp(_screen.width - padding - fireButtonSize.width / 2, padding + fireButtonSize.height / 2);
    _fireButton = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, buttonRadius * 2, buttonRadius * 2)];
    fireButtonSkin.button = _fireButton;
    [self addChild:fireButtonSkin];
}

-(void)setUpSneakyPauseButton
{
    int padding = 15, buttonRadius = 12;
    SneakyButtonSkinnedBase *pauseButtonSkin = [[SneakyButtonSkinnedBase alloc] init];
    pauseButtonSkin.defaultSprite = [ColoredCircleSprite circleWithColor: ccc4(255, 255, 0, 255)radius:buttonRadius];
    CGSize pauseButtonSize = pauseButtonSkin.contentSize;
    pauseButtonSkin.position = ccp(_screen.width - padding - pauseButtonSize.width / 2, _screen.height - padding - pauseButtonSize.height / 2);
    _pauseButton = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, buttonRadius * 2, buttonRadius * 2)];
    pauseButtonSkin.button = _pauseButton;
    [self addChild:pauseButtonSkin];
}


@end



















