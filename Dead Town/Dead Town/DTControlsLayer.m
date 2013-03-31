//
//  DTJoystickLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "ColoredCircleSprite.h"
#import "DTGameLayer.h"
#import "SneakyJoystick.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"
#import "DTButton.h"

@implementation DTControlsLayer

@synthesize isPausing = _isPausing;
@synthesize dominantHand = _dominantHand;
@synthesize controllerType = _controllerType;

+(id)controlsLayerWithGameLayer:(DTGameLayer *)gameLayer controllerType:(ControllerType)controllerType controllerDelegate:(id <DTControllerDelegate>)controllerDelegate dominantHand:(DominantHand)dominantHand
{
    return [[self alloc] initWithGameLayer:gameLayer controllerType:(ControllerType)controllerType controllerDelegate:controllerDelegate dominantHand:(DominantHand)dominantHand];
}

-(id)initWithGameLayer:(DTGameLayer *)gameLayer controllerType:(ControllerType)controllerType controllerDelegate:(id <DTControllerDelegate>)controllerDelegate dominantHand:(DominantHand)dominantHand
{
    if ((self = [super init]))
    {
        // Save some local variables
        _gameLayer = gameLayer;
        _director = [CCDirector sharedDirector];
        _screen = _director.winSize;
        _controllerDelegate = controllerDelegate;
        _dominantHand = dominantHand;
        _controllerDelegate = controllerDelegate;
        
        // Create the buttons and what-nots
        if (controllerType == ControllerTypeJoystick)
            [self addJoystick];
        else
            [self addTiltControls];
        
        [self setUpSneakyFireButton];
        [self setUpSneakyPauseButton];
        
        // The layer essentially begins in a paused state
        [self unpause];
    }
    
    return self;
}

-(void)tick:(float)delta
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
    
    // Check for a pause
    if (_pauseButton.active)
    {
        [self pause];
        _gameLayer.isPausing = YES;
    }
}

-(void)pause
{
    [self unschedule:@selector(tick:)];
    
    if (_joystick)
        [_director.touchDispatcher removeDelegate:self];
    
    _joystickSkin.visible = NO;
}

-(void)unpause
{
    if (_joystick)
        [_director.touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO]; // Register touch events
    
    [self schedule:@selector(tick:)]; // Schedule the tick to run on the game loop
}

-(void)setControllerType:(ControllerType)controllerType
{
    if (_controllerType == controllerType) // So nothing is changing...
        return;
    
    if (_controllerType == ControllerTypeJoystick) // We're moving to the joystick from the tilt
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
    // Some variables to get the sizes of the controls
    int padding = 15, joystickRadius = 36, joystickThumbRadius = joystickRadius / 3;
    
    // Create the joystick skin from plain old dots
    _joystickSkin = [[SneakyJoystickSkinnedBase alloc] init];
    _joystickSkin.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 0, 120) radius:joystickRadius];
    _joystickSkin.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 100, 255) radius:joystickThumbRadius];
    CGSize joystickSize = _joystickSkin.contentSize;
    
    if (_dominantHand == DominantHandRight)
        _joystickSkin.position = ccp(padding + joystickSize.width / 2, padding + joystickSize.height / 2);
    else
        ;
    
    _joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, joystickRadius * 2, joystickRadius * 2)];
    _joystickSkin.joystick = _joystick;
    [self addChild:_joystickSkin];
    _joystickSkin.visible = NO;
}

-(void)removeJoystick
{
    if (_controllerType != ControllerTypeJoystick)
        return;
    
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
    if (_controllerType != ControllerTypeTilt)
        return;
    
    self.isAccelerometerEnabled = NO;
}

// Create the shoot button and add it to the layer
-(void)setUpSneakyFireButton
{
    int padding = 15, buttonRadius = 24;
    SneakyButtonSkinnedBase *fireButtonSkin = [[SneakyButtonSkinnedBase alloc] init];
    fireButtonSkin.defaultSprite = [ColoredCircleSprite circleWithColor: ccc4(255, 255, 0, 255)radius:buttonRadius];
    fireButtonSkin.activatedSprite = [ColoredCircleSprite circleWithColor: ccc4(255, 255, 0, 255)radius:buttonRadius];
    fireButtonSkin.pressSprite = [ColoredCircleSprite circleWithColor: ccc4(255, 255, 0, 255)radius:buttonRadius];
    CGSize fireButtonSize = fireButtonSkin.contentSize;
    fireButtonSkin.position = ccp(_screen.width - padding - fireButtonSize.width / 2, padding + fireButtonSize.height / 2);
    //_fireButton = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, buttonRadius * 2, buttonRadius * 2)];
    _fireButton = [DTButton buttonWithRect:CGRectMake(0, 0, buttonRadius * 2, buttonRadius * 2) isHoldable:YES delegate:_gameLayer tag:@"fire"];
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
    
    if (touchPoint.x < _screen.width / 2) // Only let the left half of the screen receive the touch events
    {
        _joystickSkin.position = touchPoint;
        _joystickSkin.visible = YES;
        [_controllerDelegate controllerMoveStarted];
    }
    
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [_director convertToGL:[touch locationInView:[_director view]]];
    
    if (touchPoint.x < _screen.width / 2) // Stops the joystick from disappearing when you take a shot
    {
        _joystickSkin.visible = NO;
        [_controllerDelegate controllerMoveEnded]; // Tell the game layer that the joystick has stopped moving
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {}

#pragma mark-

@end



















