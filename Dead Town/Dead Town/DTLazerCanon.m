//
//  LazerCanon.m
//  Dead Town
//
//  Created by David Canavan on 08/04/2013.
//
//

#import "DTLazerCanon.h"
#import "DTConstantDamageCalculator.h"
#import "DTLazerBeamNode.h"

@implementation DTLazerCanon

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:100 damageCalculator:[DTConstantDamageCalculator damageWithDamage:0.5f] range:40])
    {
        int beamCount = BEAM_COUNT;
        _beamArray = [NSMutableArray arrayWithCapacity:beamCount];
    }
    
    return self;
}

-(void)setOwner:(DTCharacter *)owner
{
    [super setOwner:owner];
    int beamCount = BEAM_COUNT;
    
    for (int i = 0; i < beamCount; i++)
        [_beamArray addObject:[DTLazerBeamNode nodeWithOrigin:owner]];
}

@end




