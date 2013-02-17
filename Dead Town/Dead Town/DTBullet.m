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

+(id)bulletWithPlayerPosition:(CGPoint)playerPosition andAngle:(float)angleOfFire withGameLayer:(DTGameLayer *)gameLayer
{
    return [[self alloc] initWithPlayerPosition:playerPosition andAngle:angleOfFire withGameLayer:gameLayer];
}

-(id)initWithPlayerPosition:(CGPoint)playerPosition andAngle:(float)angleOfFire withGameLayer:(DTGameLayer*)gameLayer
{
    if (self = [super init])
    {
        _gameLayer = gameLayer;
        _isExpired = NO; // Make sure the bullet actually exists for a little bit!
        _sprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 100, 255) radius:2];
        _sprite.position = playerPosition;
        _sprite.rotation = angleOfFire;
        [self addChild:_sprite];
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

-(void)moveToPoint:(CGPoint)point
{
    _sprite.position = point;
}

-(void)tick:(float)delta
{
    if (_isExpired)
        return; // So this means the bullet has hit a target
    
    int velocity = 400;
    float angle = CC_DEGREES_TO_RADIANS(_sprite.rotation);
    CGPoint circlePosition = ccpMult(ccpForAngle(angle), velocity * delta);
    _sprite.position = ccpAdd(_sprite.position, circlePosition);
    
    if ([_gameLayer isWallAtTileCoordinate:[_gameLayer tileCoordinateForPoint:_sprite.position]])
    {
        _isExpired = YES;
        [_gameLayer removeChild:self cleanup:NO];
    }
}

@end



