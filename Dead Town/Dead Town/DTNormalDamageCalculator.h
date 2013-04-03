//
//  DTNormalDamageCalculator.h
//  Dead Town
//
//  Created by David Canavan on 03/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTDamageCalculator.h"

#define ARC4RANDOM_MAX 0x100000000;

@interface DTNormalDamageCalculator : NSObject <DTDamageCalculator>
{
    BOOL _needToGenerate;
    float _normalVariate;
}

@property(nonatomic, readonly) float averageDamage;
@property(nonatomic, readonly) float standardDeviation;

// A damage of less than 0 is set to 0.
+(id)damageWithAverageDamage:(float)averageDamage standardDeviation:(float)standardDeviation;

@end
