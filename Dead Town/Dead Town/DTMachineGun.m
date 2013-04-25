//
//  DTMachineGun.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTMachineGun.h"
#import "DTConstantDamageCalculator.h"
#import "DTBullet.h"
#import "DTLevel.h"
#import "DTWeaponTypes.h"

@implementation DTMachineGun

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{// TODO: maybe put the constant damage thing with a default for projectiles as a singleton?
    if (self = [super initWithFireRate:MACHINE_GUN_FIRE_RATE damageCalculator:[DTConstantDamageCalculator damageWithDamage:MACHINE_GUN_DAMAGE]])
    {
        _pickupImageName = MACHINE_GUN_PICKUP_IMAGE_NAME;
    }
    
    return self;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    DTBullet *bullet = [DTBullet bulletWithPosition:start angle:angleOfFire damage:[self.damageCalculator computeDamage] maxDistance:self.range owner:self.owner level:level visible:YES];
    [level addChild:bullet]; // TODO: Have a register projectile method instead so we can do the multiplayer bit easier
}

@end
