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
    
}

@end
