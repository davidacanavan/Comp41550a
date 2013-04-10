//
//  DTMaths.h
//  Dead Town
//
//  Created by David Canavan on 09/04/2013.
//
//

#import <Foundation/Foundation.h>

#define ARC4RANDOM_MAX 0x100000000

@interface DTMaths : NSObject

+(float)uniformWithLowerBound:(float) lower andUpperBound:(float) upper;

@end
