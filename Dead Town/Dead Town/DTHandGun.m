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

@implementation DTHandGun

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:6 damageCalculator:[DTConstantDamageCalculator damageWithDamage:51]])
    {
        
    }
    
    return self;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    DTBullet *bullet = [DTBullet bulletWithPosition:start angle:angleOfFire damage:[_damageCalculator computeDamage] maxDistance:self.range owner:self.owner level:level];
    [level addChild:bullet];
}

@end








