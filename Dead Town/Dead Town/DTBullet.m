//
//  NonBouncingBullet.m
//  Dead Town
//
//  Created by David Canavan on 15/02/2013.
//
//

#import "DTBullet.h"

@implementation DTBullet

@synthesize isExpired = _isExpired;
@synthesize damage = _damage;
@synthesize maxDistance = _maxDistance;
@synthesize initialPosition = _initialPosition;

+(id)bulletWithPosition:(CGPoint)initialPosition andAngle:(float)angleOfFire damage:(float)damage maxDistance:(float)maxDistance owner:(DTCharacter *)owner withGameLayer:(DTGameLayer *)gameLayer
{
    return [[self alloc] initWithPosition:initialPosition andAngle:angleOfFire damage:damage maxDistance:maxDistance owner:owner withGameLayer:gameLayer];
}

-(id)initWithPosition:(CGPoint)initialPosition andAngle:(float)angleOfFire damage:(float)damage maxDistance:(float)maxDistance owner:(DTCharacter *)owner withGameLayer:(DTGameLayer*)gameLayer
{
    if (self = [super init])
    {
        _gameLayer = gameLayer;
        _isExpired = NO; // Make sure the bullet actually exists for a little bit!
        _sprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 100, 255) radius:2]; // TODO: Allow various sprites for this
        _sprite.position = initialPosition;
        _initialPosition = initialPosition;
        _sprite.rotation = angleOfFire; // Make sure the bullet travels in the correct direction
        _damage = damage;
        _maxDistance = maxDistance;
        _owner = owner;
        [self addChild:_sprite];
        [self scheduleUpdate];
    }
    
    return self;
}

-(void)moveToPoint:(CGPoint)point
{
    _sprite.position = point;
}

-(void)update:(ccTime)delta
{
    if (_isExpired)
        return; // So this means the bullet has hit a target
    
    int velocity = 400;
    float angle = CC_DEGREES_TO_RADIANS(_sprite.rotation);
    CGPoint circlePosition = ccpMult(ccpForAngle(angle), velocity * delta);
    CGPoint newPosition = ccpAdd(_sprite.position, circlePosition);
    _sprite.position = newPosition;
    // So if we're at -1 then the caller doesn't care about distance - only walls
    BOOL isPastMaxDistance = _maxDistance == -1 ? NO : ccpDistance(newPosition, _initialPosition) > _maxDistance;
    
    // So if we've hit a wall we stop the bullet or if we've gone further than we allow.
    if ([_gameLayer isWallAtPosition:(newPosition)] || isPastMaxDistance)
    {
        _isExpired = YES;
        [_gameLayer removeChild:self cleanup:NO];
    }
}

@end



