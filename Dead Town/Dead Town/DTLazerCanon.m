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
#import "DTLevel.h"
#import "DTCharacter.h"
#import "DTLifeModel.h"

@implementation DTLazerCanon

+(id)weapon
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super initWithFireRate:100 damageCalculator:[DTConstantDamageCalculator damageWithDamage:3.0f] range:40])
    {
    }
    
    return self;
}

-(void)setOwner:(DTCharacter *)owner
{
    [super setOwner:owner];
    _lazerBeam = [DTLazerBeamNode nodeWithOrigin:owner];
    [self addChild:_lazerBeam]; // So they can get the callback
    _lazerBeam.visible = NO;
}

-(void)onFireAccepted:(float)angleOfFire from:(CGPoint)start level:(DTLevel *)level
{
    NSMutableArray *closestEnemies = [level closestNumberOf:1 enemiesToPlayer:(DTPlayer *) self.owner]; // TODO: I won't let a zombie own this one! not a big deal for now but better to be correct in future in case i change my mind
    
    if (closestEnemies) // TODO: fire more than 1 lazer but it's not a big deal right now
    {
        DTCharacter *enemy = [closestEnemies objectAtIndex:0];
        _lazerBeam.target = enemy;
        _lazerBeam.visible = YES;
        enemy.lifeModel.life -= [self.damageCalculator computeDamage];
    }
}

-(void)notifyHoldFireStart
{
    _lazerBeam.isHoldFiring = YES;
    
    if (_lazerBeam.target != nil) // If we've no target then there's no need to make the lazer visible
        _lazerBeam.visible = YES;
}

-(void)notifyHoldFireStop
{
    _lazerBeam.visible = NO;
    _lazerBeam.isHoldFiring = NO;
}

@end




















