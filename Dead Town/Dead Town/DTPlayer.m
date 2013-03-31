//
//  DTPlayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTPlayer.h"
#import "DTBullet.h"
#import "DTOptions.h"
#import "SimpleAudioEngine.h"
#import "DTLifeModel.h"

@implementation DTPlayer

// Class method to allocate the class and call the constructor
+(id)playerAtPosition:(CGPoint)position gameLayer:(DTGameLayer *)gameLayer life:(float)life
{
    return [[self alloc] initWithPlayerAtPosition:position gameLayer:gameLayer life:life];
}

-(id)initWithPlayerAtPosition:(CGPoint)position gameLayer:(DTGameLayer *)gameLayer life:(float)life
{
    if ((self = [super initWithPosition:position gameLayer:gameLayer life:life characterType:CharacterTypeHero]))
    {
    }
    
    return self;
}

// Override - Set up the animations in the superclass call
-(CCSprite *)loadSpriteAndAnimations
{
    // Set up the animation frames
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"WalkingMan.png" capacity:10];
    [self addChild:spriteBatchNode]; // Doesn't render apparently but still needs to be part of the tree
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"WalkingMan.plist"];
    NSMutableArray *frames = [NSMutableArray array];
    
    for (int i = 0; i < 8; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Sprite%d.png", i]];
        [frames addObject:frame];
    }
    
    _movingAnimation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f]; // TODO: should i cache the animation or what?
    _movingAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_movingAnimation]];
    return [CCSprite spriteWithSpriteFrameName:@"Sprite0.png"];
}

-(void)notifyMovementStart
{
    // A boolean to add extra safety to the calls - in case anything trips over each other
    if (!_isMovingActionRunning)
    {
        [_sprite runAction:_movingAction];
        _isMovingActionRunning = YES;
    }
}

-(void)notifyMovementSpeed:(float)speed
{
}

-(void)notifyMovementEnd
{
    if (_isMovingActionRunning)
    {
        [_sprite stopAction:_movingAction];
        _sprite.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Sprite0.png"];
        _isMovingActionRunning = NO;
    }
}

-(void)fire
{
    [super fire];
    
    self.lifeModel.life -= 10;
    
    if (_options.playSoundEffects)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Pew.m4a"];
}

@end














