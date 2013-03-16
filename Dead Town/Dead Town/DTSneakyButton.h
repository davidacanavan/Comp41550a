//
//  DTButton.h
//  Dead Town
//
//  Created by David Canavan on 12/03/2013.
//
//

#import "SneakyButton.h"
#import "DTSneakyButtonDelegate.h"

/**
 * I'll just explain the necessity for this class.
 * Essentially sneaky button is widely used by the cocos2d community, the general idea is to check the active property
 * on every iteration of the game loop. There are a few problems with this, for one it can be a true a few times in a game loop
 * (2 on my device) so it'll result in 2 calls to fire. Additionally I need the hold functionality to be called on every iteration
 * of the game loop if there's a button hold whereas the button has no method to check if the active state is a result 
 * of a hold or not, hence the class. Also i've put it into a nice listener/delegate pattern.
 */
@interface DTSneakyButton : SneakyButton
{
    @private
    id <DTSneakyButtonDelegate> _delegate;
    BOOL _isPossibleHold;
    BOOL _hasHoldStarted;
    float _currentHoldTime;
    float _qualifyingTimeForHold;
}

@property(nonatomic, strong) NSString *tag;

+buttonWithRect:(CGRect)rect isHoldable:(BOOL)isHoldable delegate:(id <DTSneakyButtonDelegate>)delegate tag:(NSString *) tag;

@end
