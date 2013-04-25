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
#import "DTHandGun.h"
#import "DTLazerCanon.h"

@implementation DTPlayer

// Class method to allocate the class and call the constructor
+(id)playerWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life
{
    return [[self alloc] initWithLevel:level position:position life:life];
}

+(id)playerWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life firstLifeModelDelegate:(id <DTLifeModelDelegate>)firstDelegate
{
    DTPlayer *player = [[self alloc] initWithLevel:level position:position life:life];
    [player.lifeModel addDelegate:firstDelegate]; // Add the delegate
    return player;
}

-(id)initWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life;
{
    if ((self = [super initWithLevel:level position:position life:life characterType:CharacterTypeHero velocity:-1]))
    {
        // No need to do anything here, the superclass call takes care of initialisation
        // I kept this here in case I wan't to customise some stuff
        //self.weapon = [DTHandGun weapon];
        self.weapon = [DTLazerCanon weapon];
    }
    
    return self;
}

// Override - Set up the animations in the superclass call
-(CCSprite *)loadSpriteAndAnimations
{
    // Set up the animation frames
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"player_01.png" capacity:10];
    [self addChild:spriteBatchNode]; // Doesn't render apparently but still needs to be part of the tree
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player_01.plist"];
    NSMutableArray *frames = [NSMutableArray array];
    
    for (int i = 0; i < 8; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"player_01_0%d.png", i]];
        [frames addObject:frame];
    }
    
    _defaultFrameName = @"player_01_00.png";
    _movingAnimation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f]; // TODO: should i cache the animation or what?
    _movingAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_movingAnimation]];
    return [CCSprite spriteWithSpriteFrameName:_defaultFrameName];
}

-(void)onFireSuccess
{
    [super onFireSuccess];
    
    if (_options.playSoundEffects)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Pew.m4a"];
}

-(BOOL)firesVisibleProjectile
{
    return YES;
}

@end














