//
//  DTButton.m
//  Dead Town
//
//  Created by David Canavan on 12/03/2013.
//
//

#import "DTSneakyButton.h"

@implementation DTSneakyButton

@synthesize tag = _tag;

+buttonWithRect:(CGRect)rect isHoldable:(BOOL)isHoldable delegate:(id <DTSneakyButtonDelegate>)delegate tag:(NSString *) tag
{
    return [[self alloc] initWithRect:rect isHoldable:isHoldable delegate:delegate tag:tag];
}

-(id)initWithRect:(CGRect)rect isHoldable:(BOOL)holdable delegate:(id <DTSneakyButtonDelegate>)delegate tag:(NSString *) tag
{
    if (self = [super initWithRect:rect])
    {
        self.isHoldable = holdable;
        _delegate = delegate;
        _qualifyingTimeForHold = 5.0 / 60;
        _currentHoldTime = 0;
        _tag = tag;
        [self schedule:@selector(gameLoopUpdate:)]; // Check for presses and so forth
    }
    
    return self;
}

-(void)gameLoopUpdate:(float)delta
{
    if (self.active)
    {
        [_delegate buttonPressed:self];
        self.active = NO; // Stop double-fire problem with the button
        
        if (self.isHoldable)
            _isPossibleHold = YES; // So we can check this next time the game loop runs around
    }
    else if (_isPossibleHold && self.isHoldable) // So we may be holding the button
    {
        _currentHoldTime += delta;

        if (_currentHoldTime >= _qualifyingTimeForHold) // Check if we've held the button long enough
        {
            if (!_hasHoldStarted)
            {
                [_delegate buttonHoldStarted:self];
                _hasHoldStarted = YES;
            }
            else
                [_delegate buttonHoldContinued:self];
        }
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super ccTouchEnded:touch withEvent:event];
    
    if (isHoldable)
    {
        if (_currentHoldTime >= _qualifyingTimeForHold) // Then we were holding but have let go
            [_delegate buttonHoldEnded:self];
    
        _currentHoldTime = 0; // Reset the hold checks anyway
        _isPossibleHold = NO;
        _hasHoldStarted = NO;
    }
}

@end
