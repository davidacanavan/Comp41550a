//
//  DTShotgun.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTShotgun.h"
#import "DTConstantDamageCalculator.h"
#import "DTBullet.h"
#import "DTLevel.h"
#import "DTWeaponTypes.h"

@implementation DTShotgun

#pragma mark-
#pragma Initialisation

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:SHOTGUN_FIRE_RATE damageCalculator:[DTConstantDamageCalculator damageWithDamage:SHOTGUN_DAMAGE]])
    {
        _numberOfBulletsPerShot = SHOTGUN_DEFAULT_BULLET_COUNT;
        _angularSpread = SHOTGUN_DEFAULT_ANGULAR_SPREAD;
        _pickupImageName = SHOTGUN_PICKUP_IMAGE_NAME;
    }
    
    return self;
}

#pragma mark-
#pragma mark Superclass Overrides

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    // Let's fire lots of bullets at the same time!!!
    for (float angleChange = -_angularSpread / 2; angleChange < _angularSpread / 2; angleChange += _angularSpread / _numberOfBulletsPerShot)
    {
        DTBullet *bullet = [DTBullet bulletWithPosition:start angle:angleOfFire + angleChange damage:[self.damageCalculator computeDamage] maxDistance:self.range owner:self.owner level:level visible:YES];
        [level addChild:bullet];
    }
}

#pragma mark-
#pragma mark Property Overrides

-(void)setNumberOfBulletsPerShot:(int)numberOfBulletsPerShot
{
    _numberOfBulletsPerShot = (int) max(min(numberOfBulletsPerShot, SHOTGUN_MAX_BULLET_COUNT), SHOTGUN_MIN_BULLET_COUNT);
}

-(void)setAngularSpread:(float)angularSpread
{
    _angularSpread = (int) max(min(angularSpread, SHOTGUN_MAX_ANGULAR_SPREAD), SHOTGUN_MIN_ANGULAR_SPREAD);
}

@end







