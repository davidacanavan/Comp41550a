//
//  DTConstantDamage.m
//  Dead Town
//
//  Created by David Canavan on 03/04/2013.
//
//

#import "DTConstantDamageCalculator.h"

@implementation DTConstantDamageCalculator

+(id)damageWithDamage:(float)damage
{
    return [[self alloc] initWithDamage:damage];
}

-(id)initWithDamage:(float)damage
{
    if (self = [super init])
    {
        _damage = damage;
    }
    
    return self;
}

-(float)computeDamage
{
    return _damage;
}

@end
