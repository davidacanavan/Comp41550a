//
//  DTWeapon.m
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import "DTWeapon.h"
#import "DTBullet.h"
#import "DTGameLayer.h"

@implementation DTWeapon

+(id)weaponWithFireRate:(float)fireRate
{
    return [[self alloc] initWithFireRate:fireRate];
}

-(id)initWithFireRate:(float)fireRate
{
    if (self = [super init])
    {
        _minimumTimeBetweenFires = 1.0f / fireRate; // Convert to absolute time
        _timeSinceLastFire = 0; // Assume they haven't fired yet
        [self scheduleUpdate];
    }
    
    return self;
}

-(BOOL)fireAtAngle:(float)angleOfFire from:(CGPoint)start gameLayer:(DTGameLayer *)gameLayer
{
    if (_timeSinceLastFire >= _minimumTimeBetweenFires) // Then we can fire... like a boss
    {
        // TODO: Do the fire
        _timeSinceLastFire = 0;
        DTBullet *bullet = [DTBullet bulletWithPosition:start andAngle:angleOfFire damage:10 maxDistance:-1 owner:_owner withGameLayer:gameLayer];
        [gameLayer addChild:bullet];
        return YES;
    }
    
    return NO;
}

-(void)update:(ccTime)delta
{
    _timeSinceLastFire += delta;
}

@end








