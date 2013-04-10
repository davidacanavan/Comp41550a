//
//  DTMaths.m
//  Dead Town
//
//  Created by David Canavan on 09/04/2013.
//
//

#import "DTMaths.h"

@implementation DTMaths

+(float)uniformWithLowerBound:(float) lower andUpperBound:(float) upper
{
    return (((float) arc4random()) / ARC4RANDOM_MAX) * (upper - lower) + lower;
}

@end
