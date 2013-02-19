//
//  DTStraightLineZombie.m
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "DTStraightLineZombie.h"

@implementation DTStraightLineZombie

+(id)zombieWithPlayer:(DTPlayer *)player runningDistance:(float)runningDistance gameLayer:(DTGameLayer *)gameLayer position:(CGPoint)position life:(float)life maxAttacksPerSecond:(int)maxAttacksPerSecond
{
    return [[self alloc] initWithPlayer:player runningDistance:runningDistance gameLayer:gameLayer position:position life:life maxAttacksPerSecond:(int)maxAttacksPerSecond];
}

-(id)initWithPlayer: (DTPlayer *)player runningDistance:(float)runningDistance gameLayer:(DTGameLayer *)gameLayer position:(CGPoint)position life:(float)life maxAttacksPerSecond:(int)maxAttacksPerSecond
{
    CCSprite *sprite = [CCSprite spriteWithFile:@"zombie_90%-11.png"];
    //ColoredCircleSprite *sprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 200) radius:10];
    
    if (self = [super initWithPosition:position gameLayer:gameLayer sprite:sprite life:life maxAttacksPerSecond:maxAttacksPerSecond])
    {
        _player = player;
        _runningDistance = runningDistance;
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

-(void)tick:(float)delta
{
    int velocity = 120;
    CGPoint player = [_player getPosition];
    CGPoint zombie = _sprite.position;
    float distance = ccpDistance(player, zombie);
    
    if (distance < _runningDistance) // Then run after the player!!!
    {
        if (ccpFuzzyEqual(player, zombie, 15))
            return;
        else if ([_gameLayer isWallAtPosition:zombie])
        {
            [self moveToPosition:_previousPosition];
            return; // So if the zombie is in a wall he doesn't have a line of sight anymore or else he's eating you already
        }
        
        float movingDistance = velocity * delta;
        float slope = ((float) (player.y - zombie.y)) / (player.x - zombie.x);
        float c = player.y - slope * player.x; // The y-intercept
        float xComponentFactor = cos(atanf(slope));
        float x = zombie.x + movingDistance * xComponentFactor * (player.x < zombie.x ? -1 : 1);
        float y = slope * x + c;
        CGPoint newPosition = ccp(x, y);
        [self moveToPosition:newPosition];
        [self turnToFacePosition:player];
    }
}

@end











