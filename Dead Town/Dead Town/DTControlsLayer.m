//
//  DTJoystickLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTControlsLayer.h"
#import "ColoredCircleSprite.h"
#import "SneakyJoystick.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"
#import "DTButton.h"
#import "HandyFunctions.h"

@implementation DTControlsLayer

@synthesize isPausing = _isPausing;
@synthesize dominantHand = _dominantHand;
@synthesize controllerType = _controllerType;

#pragma mark-
#pragma mark Initialisation

+(id)layerWithControllerType:(DTControllerType)controllerType controllerDelegate:(id <DTControllerDelegate>)controllerDelegate buttonDelegate:(id <DTButtonDelegate>)buttonDelegate dominantHand:(DTDominantHand)dominantHand
{
    return [[self alloc] initWithControllerType:(DTControllerType)controllerType controllerDelegate:controllerDelegate buttonDelegate:(id <DTButtonDelegate>)buttonDelegate dominantHand:(DTDominantHand)dominantHand];
}

-(id)initWithControllerType:(DTControllerType)controllerType controllerDelegate:(id <DTControllerDelegate>)controllerDelegate buttonDelegate:(id <DTButtonDelegate>)buttonDelegate dominantHand:(DTDominantHand)dominantHand
{
    if ((self = [super init]))
    {
        // Save some local variables
        _director = [CCDirector sharedDirector];
        _screen = _director.winSize;
        _controllerDelegate = controllerDelegate;
        _dominantHand = dominantHand;
        _controllerDelegate = controllerDelegate;
        _buttonDelegate = buttonDelegate;
        
        if (controllerType == DTControllerTypeJoystick)
            [self addJoystick];
        else
            [self addTiltControls];
        
        [self setUpSneakyFireButton];
        [self setUpSneakyPauseButton];
        
        _label = [CCLabelBMFont labelWithString:@"Joystick will appear\non left-hand side\nwhen pressed!" fntFile:@"text_font.fnt"];
        [self addChild:_label];
        _label.position = ccp(15 + _screen.width / 4, _screen.height / 2);
        CCBlink *blink = [CCBlink actionWithDuration:10 blinks:10];
        [_label runAction:blink];
        
        // The layer essentially begins in a paused state
        [self unpause];
    }
    
    return self;
}

-(void)update:(ccTime)delta
{
    // So we're moving the character a little bit - so tell the game layer to move him!
    if (_joystick)
    {
        if(!CGPointEqualToPoint(_joystick.stickPosition, CGPointZero))
            [_controllerDelegate controllerUpdated:_joystick.velocity delta:delta];
    }
    else // I'm talking tilt controls baby!
        if (!CGPointEqualToPoint(_tiltControlVelocity, CGPointZero))
            [_controllerDelegate controllerUpdated:_tiltControlVelocity delta:delta];
}

-(void)unpause
{
    if (_joystick)
        [_director.touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO]; // Register touch events
    
    [self scheduleUpdate]; // Schedule the tick to run on the game loop
}

-(void)setControllerType:(DTControllerType)controllerType
{
    if (_controllerType == controllerType) // So nothing is changing...
        return;
    
    if (controllerType == DTControllerTypeJoystick) // We're moving to the joystick from the tilt
    {
        [self removeTiltControls];
        [self addJoystick];
    }
    else // Setting up tilt controls
    {
        [self removeJoystick];
        [self addTiltControls];
    }
    
    _controllerType = controllerType;
}

// Create the joystick and add it to the layer
-(void)addJoystick
{
    CCSprite *background = [CCSprite spriteWithFile:@"joystick_back.png"];
    CCSprite *thumb = [CCSprite spriteWithFile:@"joystick_nav.png"];
    
    // Create the joystick skin from plain old dots
    _joystickSkin = [[SneakyJoystickSkinnedBase alloc] init];
    _joystickSkin.backgroundSprite = background;
    _joystickSkin.thumbSprite = thumb;
    _joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, background.contentSize.width, background.contentSize.height)];
    _joystickSkin.joystick = _joystick;
    [self addChild:_joystickSkin];
    _joystickSkin.visible = NO;
}

-(void)removeJoystick
{
    [self removeChild:_joystick cleanup:NO];
    _joystick = nil;
}

-(void)addTiltControls
{
    self.isAccelerometerEnabled = YES;
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1 / 60.0f;
    accelerometer.delegate = self;
    
    _wasTilting = NO;
    _lastAccelerometerTime = 0;
}

-(void)removeTiltControls
{
    self.isAccelerometerEnabled = NO;
}

-(void)setDominantHand:(DTDominantHand)dominantHand
{
    if (dominantHand == _dominantHand) // No change
        return;
    
    // Ok so we're changing to a different hand
    if (dominantHand == DTDominantHandLeft)
    { // Pause button on the top left, fire button on the bottom left
        [HandyFunctions layoutNodeFromGooeyConstants:_pauseButtonSkin toCorner:DTLayoutCornerTopLeft];
        [HandyFunctions layoutNodeFromGooeyConstants:_fireButtonSkin toCorner:DTLayoutCornerBottomLeft];
    }
    else
    {
        [HandyFunctions layoutNodeFromGooeyConstants:_pauseButtonSkin toCorner:DTLayoutCornerTopRight];
        [HandyFunctions layoutNodeFromGooeyConstants:_fireButtonSkin toCorner:DTLayoutCornerBottomRight];
    }
    
    _dominantHand = dominantHand;
}

// Create the shoot button and add it to the layer
-(void)setUpSneakyFireButton
{
    _fireButtonSkin = [[SneakyButtonSkinnedBase alloc] init];
    CCSprite *sprite = [CCSprite spriteWithFile:@"fire_button.png"];
    _fireButtonSkin.defaultSprite = sprite;
    
    [HandyFunctions layoutNodeFromGooeyConstants:_fireButtonSkin toCorner:DTLayoutCornerBottomRight];
    
    _fireButton = [DTButton buttonWithRect:CGRectMake(0, 0, sprite.contentSize.width, sprite.contentSize.height) isHoldable:YES delegate:_buttonDelegate tag:@"fire"]; // TODO: I know this is a bad way to handle this! I will change!!!!
    _fireButtonSkin.button = _fireButton;
    [self addChild:_fireButtonSkin];
}

-(void)setUpSneakyPauseButton
{
    //int buttonRadius = 12;
    _pauseButtonSkin = [[SneakyButtonSkinnedBase alloc] init];
    CCSprite *sprite = [CCSprite spriteWithFile:@"pause_button.png"];
    _pauseButtonSkin.defaultSprite = sprite;//[ColoredCircleSprite circleWithColor: ccc4(255, 255, 0, 255)radius:buttonRadius];

    [HandyFunctions layoutNodeFromGooeyConstants:_pauseButtonSkin toCorner:DTLayoutCornerTopRight];
    
    _pauseButton = [DTButton buttonWithRect:CGRectMake(0, 0, sprite.contentSize.width, sprite.contentSize.height) isHoldable:NO delegate:_buttonDelegate tag:@"pause"];
    _pauseButtonSkin.button = _pauseButton;
    [self addChild:_pauseButtonSkin];
}

#pragma mark-
#pragma mark Delegate Implementations

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    // So for landscape mode we swap the x and the y's and minus the x one!
    float timestamp = (float) acceleration.timestamp;
    float minimumSensitivity = 0.1;
    float sensitivity = 0.3;
    //float calibration = 0.5; TODO: Tilt control calibrations
    float x = acceleration.y, y = -acceleration.x;
    
    if (!(fabsf(x) < minimumSensitivity && fabsf(y) < minimumSensitivity))
    {
        if (!_wasTilting) // So we weren't tilting before but we are now!
            [_controllerDelegate controllerMoveStarted];
        
        float sx = fmaxf(fminf(x, sensitivity), -sensitivity) / sensitivity;
        float sy = fmaxf(fminf(y, sensitivity), -sensitivity) / sensitivity;
        _tiltControlVelocity = ccp(sx, sy);
        _wasTilting = YES;
    }
    else // The actual tilt detection is done on the game loop to avoid any animation stuttering
    {
        if (_wasTilting) // So now we've stopped tilting altogether
        {
            _tiltControlVelocity = CGPointZero;
            [_controllerDelegate controllerMoveEnded];
        }
        
        _wasTilting = NO;
    }
    
    _lastAccelerometerTime = timestamp;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [_director convertToGL:[touch locationInView:[_director view]]];
     // Only let the left half of the screen receive the touch events if it's right hand dominant
    BOOL receiveTouchEvent = _dominantHand == DTDominantHandRight ? touchPoint.x < _screen.width / 2 : touchPoint.x > _screen.width / 2;
    
    
    if (receiveTouchEvent)
    {
        _joystickSkin.position = touchPoint;
        _joystickSkin.visible = YES;
        [_controllerDelegate controllerMoveStarted];
    }
    
    if (_label)
    {
        [_label removeFromParentAndCleanup:NO];
        _label = nil;
    }
    
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [_director convertToGL:[touch locationInView:[_director view]]];
    // Same idea as in ccTouchBegan
    BOOL receiveTouchEvent = _dominantHand == DTDominantHandRight ? touchPoint.x < _screen.width / 2 : touchPoint.x > _screen.width / 2;
    
    if (receiveTouchEvent)
    {
        _joystickSkin.visible = NO;
        [_controllerDelegate controllerMoveEnded]; // Tell the game layer that the joystick has stopped moving
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {}

#pragma mark-

// This is a fix for when we pop a new scene and the player keeps on moving
-(void)onExit
{
    [super onExit];
    [_joystick ccTouchEnded:nil withEvent:nil];
}

@end



















