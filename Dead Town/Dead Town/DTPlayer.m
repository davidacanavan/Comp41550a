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
+(id)playerWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life
{
    return [[self alloc] initWithLevel:level position:position life:life];
}

-(id)initWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life;
{
    if ((self = [super initWithLevel:level position:position life:life characterType:CharacterTypeHero velocity:-1]))
    {
        // No need to do anything here, the superclass call takes care of initialisation
        // I kept this here in case I wan't to customise some stuff
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
        [self.sprite runAction:_movingAction];
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
        [self.sprite stopAction:_movingAction];
        self.sprite.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Sprite0.png"];
        _isMovingActionRunning = NO;
    }
}

-(void)onFireSuccess
{
    [super onFireSuccess];
    
    if (_options.playSoundEffects)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Pew.m4a"];
}

@end














