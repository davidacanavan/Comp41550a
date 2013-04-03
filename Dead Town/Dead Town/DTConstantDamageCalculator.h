//
//  DTConstantDamage.h
//  Dead Town
//
//  Created by David Canavan on 03/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTDamageCalculator.h"

@interface DTConstantDamageCalculator : NSObject <DTDamageCalculator>

@property(nonatomic, readonly) float damage;

// A damage of less than 0 is set to 0.
+(id)damageWithDamage:(float)damage;

@end
