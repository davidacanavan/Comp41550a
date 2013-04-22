//
//  NonBouncingBullet.m
//  Dead Town
//
//  Created by David Canavan on 15/02/2013.
//
//

#import "DTBullet.h"
#import "DTLifeModel.h"
#import "DTLevel.h"

@implementation DTBullet

@synthesize isExpired = _isExpired;
@synthesize damage = _damage;
@synthesize maxDistance = _maxDistance;
@synthesize initialPosition = _initialPosition;

+(id)bulletWithPosition:(CGPoint)initialPosition angle:(float)angleOfFire damage:(float)damage maxDistance:(float)maxDistance owner:(DTCharacter *)owner level:(DTLevel *)level visible:(BOOL)visible
{
    return [[self alloc] initWithPosition:initialPosition angle:angleOfFire damage:damage maxDistance:maxDistance owner:owner level:level visible:visible];
}

-(id)initWithPosition:(CGPoint)initialPosition angle:(float)angleOfFire damage:(float)damage maxDistance:(float)maxDistance owner:(DTCharacter *)owner level:(DTLevel *)level visible:(BOOL)visible
{
    if (self = [super init])
    {
        _level = level;
        _isExpired = NO; // Make sure the bullet actually exists for a little bit!
        
        if (visible)
            _sprite = [CCSprite spriteWithFile:@"pistol_bullet.png"]; // TODO: should probably cache this for speed
        else // This is for the enemies with invisible bullets (put the alpha and radius back when you're done!)
            _sprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 100, 255) radius:2];
    
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
    BOOL isFriendlyWithPlayer = [self.owner isFriendlyWithCharacter:_level.player];
    
    // So if we've hit a wall we stop the bullet or if we've gone further than we allow.
    if ([_level isWallAtPosition:(newPosition)] || isPastMaxDistance)
        [self registerExpiry];
    else if (!isFriendlyWithPlayer && CGRectIntersectsRect(_sprite.boundingBox, _level.player.sprite.boundingBox))
    { // Now we have to check for a collision with a player
        _level.player.lifeModel.life -= _damage;
        NSLog(@"%f", _damage);
        [self registerExpiry];
    }
    else if (isFriendlyWithPlayer) // Check for a collision with an enemy if we're the player
    {
        for (DTCharacter *villain in _level.villains)
            if (CGRectIntersectsRect(_sprite.boundingBox, villain.sprite.boundingBox))
            {
                villain.lifeModel.life -= _damage;
                [self registerExpiry];
                break;
            }
    }
}

-(void)registerExpiry
{
    _isExpired = YES;
    [_level removeChild:self cleanup:NO];
}

@end










