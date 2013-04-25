//
//  DTShotgun.h
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTWeapon.h"

@interface DTShotgun : DTWeapon

@property(nonatomic) int numberOfBulletsPerShot;
@property(nonatomic) float angularSpread; // The arc-angle in between the top-most and bottom-most bullets (if player faces to the right for example)

+(id)weapon;

@end
