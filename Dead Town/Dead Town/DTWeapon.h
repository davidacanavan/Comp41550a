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
    @protected
    float _timeSinceLastFire; // The time since the last accepted call to fire (calls can be rejeted to prevent bullet rain).
    float _minimumTimeBetweenFires;
}

// Whether this weapon belongs to the player or an enemy.
@property(nonatomic, readonly) BOOL belongsToPlayer;

// Factory initializer for a weapon.
+(id)weaponWithFireRatePerSecond:(float)fireRatePerSecond belongsToPlayer:(BOOL)belongsToPlayer;
-(void)fireAtAngle:(float)angleOfFire;
-(void)updateTimeSinceLastFire:(float)delta;

@end
