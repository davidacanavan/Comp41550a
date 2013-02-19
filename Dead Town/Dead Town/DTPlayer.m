//
//  DTPlayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTPlayer.h"

@implementation DTPlayer

@synthesize sprite = _sprite;
@synthesize previousPosition = _previousPosition;
@synthesize bulletAngle = _bulletAngle;

// Class method to allocate the class and call the constructor
+(id)playerWithPlayerAtPoint:(CGPoint)point withGameLayer:(DTGameLayer *)gameLayer
{
    return [[self alloc] initWithPlayerAtPoint:point withGameLayer:gameLayer];
}

-(id)initWithPlayerAtPoint:(CGPoint)point withGameLayer:(DTGameLayer *)gameLayer
{
    if ((self = [super init]))
    {
        //_sprite = [[ColoredCircleSprite alloc] initWithColor:ccc4(100, 40, 56, 255) radius:13];
        _sprite = [CCSprite spriteWithFile:@"man_90%-10.png"];
        _sprite.position = point;
        _gameLayer = gameLayer;
        [self addChild:_sprite];
        _options = [DTOptions sharedOptions];
    }
    
    return self;
}

-(void)movePlayerToPoint:(CGPoint)point
{
    _previousPosition = _sprite.position;
    _sprite.position = point;
}

-(CGPoint)getPosition
{
    return _sprite.position;
}

-(void)fire
{
    DTBullet *bullet = [DTBullet bulletWithPlayerPosition:_sprite.position andAngle:_bulletAngle withGameLayer:_gameLayer];
    [_gameLayer addChild:bullet];
    
    if (_options.playSoundEffects)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Pew.m4a"];
}

-(void)turnToFacePoint:(CGPoint)point;
{
    // If you ever have to go through this nightmare again remember that the cocos2d sprite rotation works with an angle the positive side of the x axis as a positive angle from the easterly side of the x-axis!!!
    CGPoint spritePosition = _sprite.position;
    float xDifference = (float) (point.x - spritePosition.x);
    float tanToHorizontalAxis = (point.y - spritePosition.y) / ((float) xDifference); // (y2 - y1) / (x2 - x1)
    // Get the inverse tan of the ratio. Convert back to degrees. Add 180 to ensure the direction is correct!
    float bulletAngle = CC_RADIANS_TO_DEGREES(atanf(tanToHorizontalAxis));
    float angleValue = -bulletAngle;
    
    if (xDifference < 0)
    {
        bulletAngle += 180;
        angleValue += 180;
    }
    
    _sprite.rotation = angleValue;
    _bulletAngle = bulletAngle;
}

@end














