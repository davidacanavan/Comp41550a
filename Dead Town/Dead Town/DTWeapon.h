//
//  DTWeapon.h
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import <Foundation/Foundation.h>

@interface DTWeapon : NSObject

// The maximum number of times the weapon can be fired per second
@property(nonatomic, readonly) float fireRate;

+(id)weaponWithFireRate:(float)fireRate;

@end
