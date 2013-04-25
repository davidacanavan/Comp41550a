//
//  DTPickup.h
//  Dead Town
//
//  Created by David Canavan on 25/04/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTCharacter.h"

@protocol DTPickup <NSObject>

-(void)applyPickupToCharacter:(DTCharacter *)character;

@end
