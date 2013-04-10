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

@implementation DTHandGun

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:4 damageCalculator:[DTConstantDamageCalculator damageWithDamage:10]])
    {
        
    }
    
    return self;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start gameLayer:(DTGameLayer *)gameLayer
{
    DTBullet *bullet = [DTBullet bulletWithPosition:start andAngle:angleOfFire
        damage:[_damageCalculator computeDamage] maxDistance:self.range owner:self.owner withGameLayer:gameLayer];
    [gameLayer addChild:bullet];
}

@end
