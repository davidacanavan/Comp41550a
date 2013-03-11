//
//  DTJoystickLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTControlsLayer.h"
#import "ColoredCircleSprite.h"

@implementation DTControlsLayer

@synthesize isPausing = _isPausing;

+(id)controlsLayerWithGameLayer:(DTGameLayer *)gameLayer useJoystick:(BOOL)useJoystick controlsListener:(id <DTControlsListener>)controlsListener
{
    return [[self alloc] initWithGameLayer:gameLayer useJoystick:useJoystick controlsListener:controlsListener];
}

-(id)initWithGameLayer:(DTGameLayer *)gameLayer useJoystick:(BOOL)useJoystick controlsListener:(id <DTControlsListener>)controlsListener
{
    if ((self = [super init]))
    {
        // Save some local variables
        _gameLayer = gameLayer;
        _director = [CCDirector sharedDirector];
        _screen = _director.winSize;
        _qualifyingTimeForHold = 5.0 / 60;
        _currentHoldTime = 0;
        _controlsListener = controlsListener;
        
        // Create the buttons and what-nots
        if (useJoystick)
            [self setUpSneakyJoystick];
        
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
    if (!CGPointEqualToPoint(_joystick.stickPosition, CGPointZero)) 
        [_controlsListener joystickUpdated:_joystick.velocity delta:delta];
    
    // Check to see if we're firing a bullet - then fire!
    if (_fireButton.active)
    {
        _gameLayer.isFiring = YES;
        _fireButton.active = NO; // Fix to stop double-fire
        _isPossibleHold = YES; // So we can check this next time the game loop runs around
    }
    else if (_isPossibleHold)
    {
        _currentHoldTime = min(_currentHoldTime + delta, _qualifyingTimeForHold);
        
        // Check if we've held the button long enough
        if (_currentHoldTime >= _qualifyingTimeForHold)
            [_gameLayer setIsHoldFiring:YES andIsJoystickStillMoving:_joystickSkin.visible];
    }
    
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
    [_director.touchDispatcher removeDelegate:self];
    _joystickSkin.visible = NO;
}

-(void)unpause
{
    [_director.touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO]; // Register touch events
    [self schedule:@selector(tick:)]; // Schedule the tick to run on the game loop
}

// Create the joystick and add it to the layer
-(void)setUpSneakyJoystick
{
    // Some variables to get the sizes of the controls
    int padding = 15, joystickRadius = 36, joystickThumbRadius = joystickRadius / 3;
    
    // Create the joystick skin from plain old dots
    _joystickSkin = [[SneakyJoystickSkinnedBase alloc] init];
    _joystickSkin.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 0, 120) radius:joystickRadius];
    _joystickSkin.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 100, 255) radius:joystickThumbRadius];
    CGSize joystickSize = _joystickSkin.contentSize;
    _joystickSkin.position = ccp(padding + joystickSize.width / 2, padding + joystickSize.height / 2);
    _joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, joystickRadius * 2, joystickRadius * 2)];
    _joystickSkin.joystick = _joystick;
    [self addChild:_joystickSkin];
    _joystickSkin.visible = NO;
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

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [_director convertToGL:[touch locationInView:[_director view]]];
    
    if (touchPoint.x < _screen.width / 2) // Only let the left half of the screen receive the touch events
    {
        _joystickSkin.position = touchPoint;
        _joystickSkin.visible = YES;
        [_controlsListener joystickMoveStarted];
    }
    
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [_director convertToGL:[touch locationInView:[_director view]]];
    
    if (touchPoint.x < _screen.width / 2) // Stops the joystick from disappearing when you take a shot
    {
        _joystickSkin.visible = NO;
        [_controlsListener joystickMoveEnded]; // Tell the game layer that the joystick has stopped moving
    }
    else
        [_gameLayer setIsHoldFiring:NO andIsJoystickStillMoving:_joystickSkin.visible];
    
    _isPossibleHold = NO;
    _currentHoldTime = 0;
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {}

@end



















