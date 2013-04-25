//
//  DTWeaponPickup.h
//  Dead Town
//
//  Created by David Canavan on 25/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTPickup.h"

@class DTWeapon;

@interface DTWeaponPickup : NSObject <DTPickup>

@property(nonatomic, readonly) DTWeapon *weapon;
@property(nonatomic, readonly) CCSprite *sprite;

+(id)pickupWithWeapon:(DTWeapon *)weapon;

@end
