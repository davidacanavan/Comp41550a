//
//  DTWeapon.h
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DTDamageCalculator.h"

@class DTCharacter;
@class DTLevel;

@interface DTWeapon : CCNode // I extend CCNode to get the game loop update scheduled
{
    @protected
    float _timeSinceLastFire; // The time since the last accepted call to fire (calls can be rejeted to prevent bullet rain).
    float _minimumTimeBetweenFires;
    id <DTDamageCalculator> _damageCalculator;
}

// Whether this weapon belongs to the player or an enemy.
@property(nonatomic) DTCharacter *owner;
@property(nonatomic, readonly) float range;

// Factory initializer for a weapon.
+(id)weaponWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator;
-(id)initWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator;
+(id)weaponWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator range:(float)range;
-(id)initWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator range:(float)range;
-(BOOL)fireAtAngle:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level;
// Override this to do the actual firing when it's been accepted - empty by default
-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level;

@end
