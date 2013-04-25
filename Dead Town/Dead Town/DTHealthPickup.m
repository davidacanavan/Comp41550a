//
//  DTHealthPickup.m
//  Dead Town
//
//  Created by David Canavan on 25/04/2013.
//
//

#import "DTHealthPickup.h"

@implementation DTHealthPickup

+(id)pickupWithHealth:(float)health
{
    return [[self alloc] initWithHealth:health];
}

-(id)initWithHealth:(float)health
{
    if (self = [super init])
    {
        _health = health;
    }
    
    return self;
}

-(void)applyPickupToCharacter:(DTCharacter *)character
{
}

@end
