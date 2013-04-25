//
//  DTWeaponPickup.m
//  Dead Town
//
//  Created by David Canavan on 25/04/2013.
//
//

#import "DTWeaponPickup.h"

@implementation DTWeaponPickup

+(id)pickupWithWeapon:(DTWeapon *)weapon
{
    return [[self alloc] initWithWeapon:weapon];
}

-(id)initWithWeapon:(DTWeapon *)weapon
{
    if (self = [super init])
    {
        _weapon = weapon;
    }
    
    return self;
}

-(void)applyPickupToCharacter:(DTCharacter *)character
{
    
}

@end
