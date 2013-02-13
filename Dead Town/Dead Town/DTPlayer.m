//
//  DTPlayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTPlayer.h"
#import "ColoredCircleSprite.h"

@implementation DTPlayer

@synthesize sprite = _sprite;

// Class method to allocate the class and call the constructor
+(id)initWithPlayerAtPoint:(CGPoint)point parentLayer:(CCLayer *)parent
{
    return [[self alloc] initWithPlayerAtPoint:point parentLayer:parent];
}

-(id)initWithPlayerAtPoint:(CGPoint)point parentLayer:(CCLayer *)parent
{
    if ((self = [super init]))
    {
        _sprite = [[ColoredCircleSprite alloc] initWithColor:ccc4(100, 40, 56, 255) radius:12];
        _sprite.position = point;
        _parent = parent;
        [self addChild:_sprite];
    }
    
    return self;
}

-(void)movePlayerToPoint:(CGPoint)point
{
    _sprite.position = point;
}

-(void)focusMapOnPlayer
{
    //CGPoint pos = _sprite.position;
}

-(void)fire
{
    
}

// TODO: I'll have to implement this when i actually have an image for the player
-(void)turnToFacePoint:(CGPoint)point;
{
    
}

@end
