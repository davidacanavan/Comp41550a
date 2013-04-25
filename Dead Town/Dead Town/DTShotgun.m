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

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:SHOTGUN_FIRE_RATE damageCalculator:[DTConstantDamageCalculator damageWithDamage:SHOTGUN_DAMAGE]])
    {
        
    }
    
    return self;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    float angleSpread = 90; // So the bullets go out a quarter of a circle!
    
    // Let's fire lots of bullets at the same time!!!
    for (float angleChange = -angleSpread/ 2; angleChange < angleSpread / 2; angleChange += angleSpread / SHOTGUN_BULLET_COUNT)
    {
        DTBullet *bullet = [DTBullet bulletWithPosition:start angle:angleOfFire + angleChange damage:[self.damageCalculator computeDamage] maxDistance:self.range owner:self.owner level:level visible:YES];
        [level addChild:bullet];
    }
}

@end
