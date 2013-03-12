//
//  DTButton.h
//  Dead Town
//
//  Created by David Canavan on 12/03/2013.
//
//

#import "SneakyButton.h"
#import "DTSneakyButtonDelegate.h"

@interface DTSneakyButton : SneakyButton
{
    @private
    id <DTSneakyButtonDelegate> _delegate;
    BOOL _isPossibleHold;
    float _currentHoldTime;
    float _qualifyingTimeForHold;
}

+buttonWithRect:(CGRect)rect isHoldable:(BOOL)isHoldable delegate:(id <DTSneakyButtonDelegate>)delegate;

@end
