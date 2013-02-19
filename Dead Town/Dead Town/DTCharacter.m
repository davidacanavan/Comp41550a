//
//  DTCharacter.m
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "DTCharacter.h"
#import "DTGameLayer.h"

@implementation DTCharacter

@synthesize life = _life;

-(id)initWithPosition:(CGPoint)position gameLayer:(DTGameLayer *)gameLayer sprite:(CCNode *)sprite life:(float)life maxAttacksPerSecond:(int)maxAttacksPerSecond
{
    if (self = [super init])
    {
        // Get the options singleton
        _options = [DTOptions sharedOptions];
        
        // Save the instance variables and set the sprite's position
        _gameLayer = gameLayer;
        _sprite = sprite;
        _sprite.position = position;
        _life = life;
        _maxAttackRate = 1 / maxAttacksPerSecond;
        _currentFireGap = 0;
        
        // Add the sprite to the layer - I leave the actual end
        [self addChild:_sprite];
        
    }
    
    return self;
}

-(void)moveToPosition:(CGPoint)position
{
    _previousPosition = _sprite.position;
    _sprite.position = position;
}

-(void)turnToFacePosition:(CGPoint)position
{
    // If you ever have to go through this nightmare again remember that the cocos2d sprite rotation works with an angle the positive side of the x axis as a positive angle from the easterly side of the x-axis!!!
    CGPoint spritePosition = _sprite.position;
    float xDifference = (float) (position.x - spritePosition.x);
    float tanToHorizontalAxis = (position.y - spritePosition.y) / ((float) xDifference); // (y2 - y1) / (x2 - x1)
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

-(CGPoint)getPosition
{
    return _sprite.position;
}

// Ensure the player's life never goes below zero
-(void)setLife:(float)life
{
    _life = max(life, 0);
}

@end










