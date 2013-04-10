//
//  DTWeapon.m
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import "DTWeapon.h"
#import "DTBullet.h"
#import "DTGameLayer.h"

@implementation DTWeapon

+(id)weaponWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator
{
    return [[self alloc] initWithFireRate:fireRate damageCalculator:damageCalculator];
}

+(id)weaponWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator range:(float)range
{
    return [[self alloc] initWithFireRate:fireRate damageCalculator:damageCalculator range:range];
}

-(id)initWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator
{
    return [self initWithFireRate:fireRate damageCalculator:damageCalculator range:-1];
}

-(id)initWithFireRate:(float)fireRate damageCalculator:(id <DTDamageCalculator>)damageCalculator range:(float)range
{
    if (self = [super init])
    {
        _minimumTimeBetweenFires = 1.0f / fireRate; // Convert to absolute time
        _timeSinceLastFire = 0; // Assume they haven't fired yet
        _range = range;
        _damageCalculator = damageCalculator;
        [self schedule:@selector(updateTimeSinceLastFire:)];
    }
    
    return self;
}

-(BOOL)fireAtAngle:(float)angleOfFire from:(CGPoint)start gameLayer:(DTGameLayer *)gameLayer
{
    if (_timeSinceLastFire >= _minimumTimeBetweenFires) // Then we can fire... like a boss
    {
        _timeSinceLastFire = 0;
        [self onFireAccepted:angleOfFire from:start gameLayer:gameLayer];
        return YES;
    }
    
    return NO;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start gameLayer:(DTGameLayer *)gameLayer {}

-(void)updateTimeSinceLastFire:(ccTime)delta
{
    _timeSinceLastFire += delta;
}

@end








