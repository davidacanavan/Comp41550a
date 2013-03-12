//
//  DTWeapon.h
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import <Foundation/Foundation.h>

@interface DTWeapon : NSObject
{
    @private
    // The time since the last accepted call to fire (calls can be rejeted to prevent bullet rain).
    int _currentFireGap;
    // The angle of trajectory the bullet will follow.
    float _angleOfFire;
    // Whether this weapon belongs to the player or an enemy.
    BOOL _isPlayers;
}

// The maximum number of times the weapon can be fired per second.
@property(nonatomic, readonly) float fireRate;

// Factory initializer for a weapon.
+(id)weaponWithFireRate:(float)fireRate;
-(void)fireAtAngle:(float)angleOfFire;

@end
