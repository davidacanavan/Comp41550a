//
//  DTStraightLineZombie.m
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "DTStraightLineZombie.h"

@implementation DTStraightLineZombie

+(id)zombieWithPlayer:(DTPlayer *)player andRunningDistance:(float)runningDistance withGameLayer:(DTGameLayer *)gameLayer andPosition:(CGPoint)position
{
    return [[self alloc] initWithPlayer:player andRunningDistance:runningDistance withGameLayer:gameLayer andPosition:position];
}

-(id)initWithPlayer: (DTPlayer *)player andRunningDistance:(float)runningDistance withGameLayer:(DTGameLayer *)gameLayer andPosition:(CGPoint)position
{
    ColoredCircleSprite *sprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 0, 0) radius:10];
    
    if (self = [super initWithPosition:position gameLayer:gameLayer andSprite:sprite])
    {
        _player = player;
        _runningDistance = runningDistance;
        [self schedule:@selector(tick:)];
    }
    
    return self;
}

-(void)tick:(float)delta
{
    int velocity = 50;
    CGPoint player = [_player getPosition];
    CGPoint zombie = _sprite.position;
    float distance = ccpDistance(player, zombie);
    
    if (distance < _runningDistance) // Then run after the player!!!
    {
        float slope = ((float) (player.y - zombie.y)) / (player.x - zombie.x);
        float c = player.y - slope * player.x; // The y-intercept
        float x = zombie.x + velocity * delta * (player.y < zombie.y ? -1 : 1);
        float y = slope * x + c;
        _sprite.position = ccp(x, y);
    }
}

@end











