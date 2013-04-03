//
//  DTStraightLineZombie.m
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "DTStraightLineZombie.h"
#import "DTPlayer.h"
#import "DTGameLayer.h"
#import "DTWeapon.h"
#import "DTConstantDamageCalculator.h"

@implementation DTStraightLineZombie

+(id)zombieWithPlayer:(DTPlayer *)player runningDistance:(float)runningDistance gameLayer:(DTGameLayer *)gameLayer position:(CGPoint)position life:(float)life
{
    return [[self alloc] initWithPlayer:player runningDistance:runningDistance gameLayer:gameLayer position:position life:life];
}

-(id)initWithPlayer: (DTPlayer *)player runningDistance:(float)runningDistance gameLayer:(DTGameLayer *)gameLayer position:(CGPoint)position life:(float)life
{
    if (self = [super initWithPosition:position gameLayer:gameLayer life:life characterType:CharacterTypeVillian])
    {
        _player = player;
        _runningDistance = runningDistance;
        self.weapon = [DTWeapon weaponWithFireRate:2 damageCalculator:[DTConstantDamageCalculator damageWithDamage:5]
                range:50];
        [self scheduleUpdate];
    }
    
    return self;
}

-(CCSprite *)loadSpriteAndAnimations
{
    return [CCSprite spriteWithFile:@"zombie_90%-11.png"];
}

-(void)update:(ccTime)delta
{
    int velocity = 120;
    CGPoint player = [_player getPosition];
    CGPoint zombie = self.sprite.position;
    float distance = ccpDistance(player, zombie);
    
    if (distance < _runningDistance) // Then run after the player!!!
    {
        if (ccpFuzzyEqual(player, zombie, 15))
            return;
        
        float movingDistance = velocity * delta;
        float slope = ((float) (player.y - zombie.y)) / (player.x - zombie.x);
        float c = player.y - slope * player.x; // The y-intercept
        float xComponentFactor = cos(atanf(slope));
        float x = zombie.x + movingDistance * xComponentFactor * (player.x < zombie.x ? -1 : 1);
        float y = slope * x + c;
        CGPoint newPosition = ccp(x, y);
        
        // So if the zombie is in a wall he doesn't have a line of sight anymore or else he's eating you already
        if ([_gameLayer isWallAtPosition:newPosition])
            return;
        
        [self moveToPosition:newPosition];
        [self turnToFacePosition:player];
        [self fire]; // Fire at the player!!!!
    }
}

@end











