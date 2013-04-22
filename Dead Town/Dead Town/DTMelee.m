//
//  DTMelee.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTMelee.h"
#import "DTConstantDamageCalculator.h"
#import "DTBullet.h"
#import "DTLevel.h"

@implementation DTMelee

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:2 damageCalculator:[DTConstantDamageCalculator damageWithDamage:2] range:20])
    {
        
    }
    
    return self;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    DTBullet *bullet = [DTBullet bulletWithPosition:start angle:angleOfFire damage:[self.damageCalculator computeDamage] maxDistance:self.range owner:self.owner level:level visible:NO];
    [level addChild:bullet];
}

@end







