//
//  DTWeapon.m
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import "DTWeapon.h"

@implementation DTWeapon

+(id)weaponWithFireRate:(float)fireRate
{
    return [[self alloc] initWithFireRate:fireRate];
}

-(id)initWithFireRate:(float)fireRate
{
    if (self = [super init])
    {
        _fireRate = fireRate;
    }
    
    return self;
}

@end
