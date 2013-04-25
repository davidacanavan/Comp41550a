//
//  DTHealthPickup.h
//  Dead Town
//
//  Created by David Canavan on 25/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTPickup.h"

@interface DTHealthPickup : CCNode <DTPickup>

@property(nonatomic, readonly) float health;
@property(nonatomic, readonly) CCSprite *sprite;

+(id)pickupWithHealth:(float)health;

@end
