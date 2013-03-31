//
//  DTWeapon.h
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class DTCharacter;
@class DTGameLayer;

@interface DTWeapon : CCNode // I extend CCNode to get the game loop update scheduled
{
    @protected
    float _timeSinceLastFire; // The time since the last accepted call to fire (calls can be rejeted to prevent bullet rain).
    float _minimumTimeBetweenFires;
}

// Whether this weapon belongs to the player or an enemy.
@property(nonatomic) DTCharacter *owner;

// Factory initializer for a weapon.
+(id)weaponWithFireRate:(float)fireRate;
-(BOOL)fireAtAngle:(float)angleOfFire from:(CGPoint)start gameLayer:(DTGameLayer *)gameLayer;

@end
