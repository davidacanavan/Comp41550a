//
//  LazerCanon.h
//  Dead Town
//
//  Created by David Canavan on 08/04/2013.
//
//

#import "DTWeapon.h"

@class DTLazerBeamNode;

@interface DTLazerCanon : DTWeapon
{
    @private
    DTLazerBeamNode *_lazerBeam;
}

+(id)weapon;

@end
