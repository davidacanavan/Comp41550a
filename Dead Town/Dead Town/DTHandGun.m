//
//  DTHandGun.m
//  Dead Town
//
//  Created by David Canavan on 08/04/2013.
//
//

#import "DTHandGun.h"
#import "DTBullet.h"
#import "DTConstantDamageCalculator.h"
#import "DTLevel.h"
#import "DTWeaponTypes.h"

@implementation DTHandGun

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:HANDGUN_FIRE_RATE damageCalculator:[DTConstantDamageCalculator damageWithDamage:HANDGUN_DAMAGE]])
    {
        _pickupImageName = HANDGUN_PICKUP_IMAGE_NAME;
    }
    
    return self;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    DTBullet *bullet = [DTBullet bulletWithPosition:start angle:angleOfFire damage:[self.damageCalculator computeDamage] maxDistance:self.range owner:self.owner level:level visible:YES];
    [level addChild:bullet];
}

@end








