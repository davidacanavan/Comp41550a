//
//  DTButton.m
//  Dead Town
//
//  Created by David Canavan on 12/03/2013.
//
//

#import "DTSneakyButton.h"

@implementation DTSneakyButton

+buttonWithRect:(CGRect)rect isHoldable:(BOOL)isHoldable delegate:(id <DTSneakyButtonDelegate>)delegate
{
    return [[self alloc] initWithRect:rect isHoldable:isHoldable delegate:delegate];
}

-(id)initWithRect:(CGRect)rect isHoldable:(BOOL)holdable delegate:(id <DTSneakyButtonDelegate>)delegate
{
    if (self = [super initWithRect:rect])
    {
        self.isHoldable = holdable;
        _delegate = delegate;
        _qualifyingTimeForHold = 5.0 / 60;
        _currentHoldTime = 0;
        [self schedule:@selector(gameLoopUpdate:)]; // Check for presses and so forth
    }
    
    return self;
}

-(void)gameLoopUpdate:(float)delta
{
    if (self.active)
    {
        [_delegate buttonPressed];
        self.active = NO; // Stop double-fire problem with the button
        _isPossibleHold = YES; // So we can check this next time the game loop runs around
    }
    else if (self.active && _isPossibleHold) // So we may be holding the button
    {
        _currentHoldTime += delta;

        if (_currentHoldTime >= _qualifyingTimeForHold) // Check if we've held the button long enough
            [_delegate buttonHoldStarted];
    }
    else // So we're not active at all
    {
        if (_currentHoldTime >= _qualifyingTimeForHold) // Then we were holding but have let go
            [_delegate buttonHoldEnded];
        
        _currentHoldTime = 0; // Reset the hold checks
        _isPossibleHold = NO;
    }
}

@end
