//
//  DTPlayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTPlayer.h"
#import "ColoredCircleSprite.h"
#import "DTBullet.h"

@implementation DTPlayer

@synthesize sprite = _sprite;
@synthesize previousPosition = _previousPosition;

// Class method to allocate the class and call the constructor
+(id)playerWithPlayerAtPoint:(CGPoint)point withGameLayer:(DTGameLayer *)gameLayer
{
    return [[self alloc] initWithPlayerAtPoint:point withGameLayer:gameLayer];
}

-(id)initWithPlayerAtPoint:(CGPoint)point withGameLayer:(DTGameLayer *)gameLayer
{
    if ((self = [super init]))
    {
        _sprite = [[ColoredCircleSprite alloc] initWithColor:ccc4(100, 40, 56, 255) radius:13];
        _sprite.position = point;
        _gameLayer = gameLayer;
        [self addChild:_sprite];
    }
    
    return self;
}

-(void)movePlayerToPoint:(CGPoint)point
{
    _previousPosition = _sprite.position;
    _sprite.position = point;
}

-(CGPoint)getPlayerPoint
{
    return _sprite.position;
}

-(void)fire
{
    DTBullet *bullet = [DTBullet bulletWithPlayerPosition:_sprite.position andAngle:_sprite.rotation withGameLayer:_gameLayer];
    [self addChild:bullet];
}

-(void)turnToFacePoint:(CGPoint)point;
{
    
}

@end








