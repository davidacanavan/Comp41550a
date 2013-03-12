//
//  DTWeapon.m
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import "DTWeapon.h"

@implementation DTWeapon

+(id)weaponWithFireRatePerSecond:(float)fireRatePerSecond belongsToPlayer:(BOOL)belongsToPlayer
{
    return [[self alloc] initWithFireRatePerSecond:fireRatePerSecond belongsToPlayer:(BOOL)belongsToPlayer];
}

-(id)initWithFireRatePerSecond:(float)fireRatePerSecond belongsToPlayer:(BOOL)belongsToPlayer
{
    if (self = [super init])
    {
        _minimumTimeBetweenFires = 1.0f / fireRatePerSecond; // Convert to absolute time
        _timeSinceLastFire = 0; // Assume they haven't fired yet
        _belongsToPlayer = belongsToPlayer;
    }
    
    return self;
}

-(void)fireAtAngle:(float)angleOfFire {}

-(void)updateTimeSinceLastFire:(float)delta
{
    
}

@end








