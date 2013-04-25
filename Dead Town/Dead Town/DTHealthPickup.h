//
//  DTHealthPickup.h
//  Dead Town
//
//  Created by David Canavan on 25/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTPickup.h"

@interface DTHealthPickup : NSObject <DTPickup>

@property(nonatomic, readonly) float health;

+(id)pickupWithHealth:(float)health;

@end
