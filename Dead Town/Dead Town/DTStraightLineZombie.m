//
//  DTStraightLineZombie.m
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "DTStraightLineZombie.h"
#import "DTPlayer.h"
#import "DTWeapon.h"
#import "DTConstantDamageCalculator.h"
#import "DTLevel.h"

@implementation DTStraightLineZombie

+(id)zombieWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life velocity:(float)velocity player:(DTPlayer *)player runningDistance:(float)runningDistance
{
    return [[self alloc] initWithLevel:level position:position life:life velocity:velocity player:player runningDistance:runningDistance];
}

-(id)initWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life velocity:(float)velocity player:(DTPlayer *)player runningDistance:(float)runningDistance
{
    if (self = [super initWithLevel:level position:position life:life characterType:CharacterTypeVillian velocity:velocity])
    {
        _player = player;
        _runningDistance = runningDistance;
        self.weapon = [DTWeapon weaponWithFireRate:2 damageCalculator:[DTConstantDamageCalculator damageWithDamage:0.5]
                range:30];
        [self scheduleUpdate];
    }
    
    return self;
}

// Override - Set up the animations in the superclass call
-(CCSprite *)loadSpriteAndAnimations
{
    int frameCount = 7, startNumber = 1;
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"zombie_01.png" capacity:frameCount];
    [self addChild:spriteBatchNode]; // Doesn't render apparently but still needs to be part of the tree
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zombie_01.plist"];
    NSMutableArray *frames = [NSMutableArray array];
    
    for (int i = startNumber; i < startNumber + frameCount; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
            spriteFrameByName:[NSString stringWithFormat:@"zombie_01_0%d.png", i]];
        [frames addObject:frame];
    }
    
    _movingAnimation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f]; // TODO: should i cache the animation or what?
    _movingAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_movingAnimation]];
    return [CCSprite spriteWithSpriteFrameName:@"zombie_01_01.png"];
}

-(void)update:(ccTime)delta
{
    CGPoint player = [_player getPosition];
    CGPoint zombie = self.sprite.position;
    float distance = ccpDistance(player, zombie);
    
    if (distance < _runningDistance) // Then run after the player!!!
    {
        if (ccpFuzzyEqual(player, zombie, 15))
        {
            [self fire];
            return;
        }
        
        float movingDistance = _velocity * delta;
        float slope = ((float) (player.y - zombie.y)) / (player.x - zombie.x);
        float c = player.y - slope * player.x; // The y-intercept
        float xComponentFactor = cos(atanf(slope));
        float x = zombie.x + movingDistance * xComponentFactor * (player.x < zombie.x ? -1 : 1);
        float y = slope * x + c;
        CGPoint newPosition = ccp(x, y);
        
        // So if the zombie is in a wall he doesn't have a line of sight anymore or else he's eating you already
        if ([_level isWallAtPosition:newPosition])
            return;
        
        [self moveToPosition:newPosition];
        [self turnToFacePosition:player];
        [self fire]; // Fire at the player!!!!
    }
}

@end











