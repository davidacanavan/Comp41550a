//
//  LazerCanon.h
//  Dead Town
//
//  Created by David Canavan on 08/04/2013.
//
//

#import "DTWeapon.h"

#define BEAM_COUNT 3;

@interface DTLazerCanon : DTWeapon
{
    NSMutableArray *_beamArray;
}

+(id)weapon;

@end
