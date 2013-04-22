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

@implementation DTShotgun

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:5 damageCalculator:[DTConstantDamageCalculator damageWithDamage:51]])
    {
        
    }
    
    return self;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    float angleSpread = M_PI / 2; // So the bullets go out a quarter of a circle!
    int bulletCount = 8;
    
    // Let's fire lots of bullets at the same time!!!
    for (float angleChange = -angleSpread/ 2; angleChange < angleSpread / 2; angleChange += angleSpread / bulletCount)
    {
        DTBullet *bullet = [DTBullet bulletWithPosition:start angle:angleOfFire + angleChange damage:[_damageCalculator computeDamage] maxDistance:self.range owner:self.owner level:level];
        [level addChild:bullet];
    }
}

@end
