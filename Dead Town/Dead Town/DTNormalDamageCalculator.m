//
//  DTNormalDamageCalculator.m
//  Dead Town
//
//  Created by David Canavan on 03/04/2013.
//
//

#import "DTNormalDamageCalculator.h"

@implementation DTNormalDamageCalculator

+(id)damageWithAverageDamage:(float)averageDamage standardDeviation:(float)standardDeviation
{
    return [[self alloc] initDamageWithAverageDamage:averageDamage standardDeviation:standardDeviation];
}

-(id)initDamageWithAverageDamage:(float)averageDamage standardDeviation:(float)standardDeviation
{
    if (self = [super init])
    {
        _averageDamage = averageDamage;
        _standardDeviation = standardDeviation;
    }
    
    return self;
}

-(float)generateStandardUniformFrom:(float)min to:(float)max
{
    float uniform01 = ((float) arc4random()) / ARC4RANDOM_MAX;
    return (uniform01 - min) * max;
}

-(float)computeDamage
{
    if (_needToGenerate)
    {
        float u, v, s;
        
        do
        {
            u = [self generateStandardUniformFrom:-1 to:1];
            v = [self generateStandardUniformFrom:-1 to:1];
            s = u * u + v * v;
        } while (s == 0 || s >= 1);
        
        float constant = sqrtf(-2 * logf(s) / s);
        float z1 = (u * constant) * _standardDeviation + _averageDamage;
        _normalVariate = (v * constant) * _standardDeviation + _averageDamage;
        _needToGenerate = NO;
        return z1;
    }
    
    _needToGenerate = YES;
    return _normalVariate;
}

@end
