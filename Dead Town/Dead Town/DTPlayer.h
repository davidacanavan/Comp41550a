//
//  DTPlayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTCharacter.h"
#import "DTLifeModelDelegate.h"

@class DTGameLayer;
@class DTLevel;

@interface DTPlayer : DTCharacter

+(id)playerWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life;
+(id)playerWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life firstLifeModelDelegate:(id <DTLifeModelDelegate>)firstDelegate;

@end
