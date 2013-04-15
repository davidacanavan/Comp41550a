//
//  DTMenuLayer.m
//  Dead Town
//
//  Created by David Canavan on 10/02/2013.
//
//

#import "DTMenuLayer.h"
#import "DTLevelSelectScene.h"
#import "GooeyStatics.h"

@implementation DTMenuLayer

-(id)init
{
    if ((self = [super init]))
    {
        CGSize screen = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"intro_background.png"];
        backgroundSprite.position = ccp(screen.width / 2, screen.height / 2);
        [self addChild: backgroundSprite z:-1];
        
        _titleSprite = [CCSprite spriteWithFile:@"intro_title.png"];
        _titleSprite.position = ccp(screen.width / 2, screen.height + _titleSprite.boundingBox.size.height / 2);
        [self addChild: _titleSprite z:1];
        
        //[self initHeadingAnimation];
        //_headingSprite.position = ccp(screen.width / 2, screen.height / 2);
        //[self addChild:_headingSprite];
        
        CCMenuItemImage *onePlayerMenuItem = [GooeyStatics menuItemWithImageName:@"intro_one_player.png" target:self selector:@selector(onePlayerModeSelected)];
        CCMenuItemImage *twoPlayerMenuItem = [GooeyStatics menuItemWithImageName:@"intro_two_player.png" target:self selector:@selector(twoPlayerModeSelected)];
        
        _menu = [CCMenu menuWithItems:onePlayerMenuItem, twoPlayerMenuItem, nil];
        [_menu alignItemsHorizontallyWithPadding:40];
        _menu.position = ccp(screen.width / 2, -_menu.boundingBox.size.height / 2);
        [self addChild:_menu z:2];
    }
    
    return self;
}

-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    CGSize screen = [CCDirector sharedDirector].winSize;
    [_titleSprite runAction: [CCSequence actions:
                [CCMoveTo actionWithDuration:0.4 position:ccp(screen.width / 2, screen.height * 0.67)],
                [CCCallFunc actionWithTarget:self selector:@selector(animateMenuIn)],
                nil]];
}

-(void)animateMenuIn
{
    CGSize screen = [CCDirector sharedDirector].winSize;
    [_menu runAction:[CCMoveTo actionWithDuration:0.2 position:ccp(screen.width / 2, screen.height * .35)]];
}

-(void)initHeadingAnimation
{
    // Set up the animation frames
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"DTIntroAnimation.png" capacity:10];
    [self addChild:spriteBatchNode]; // Doesn't render apparently but still needs to be part of the tree
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"DTIntroAnimation.plist"];
    NSMutableArray *frames = [NSMutableArray array];
    
    for (int i = 1; i <= 10; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"DT Intro_%02d.png", i]];
        [frames addObject:frame];
    }
    
    _headingSprite = [CCSprite spriteWithSpriteFrameName:@"DT Intro_01.png"];
    _headingAnimation = [CCAnimation animationWithSpriteFrames:frames delay:0.5f]; // TODO: should i cache the animation or what?
    [CCAnimate actionWithAnimation:_headingAnimation];
}

// The one player mode has been selected - now we just have to replace the scene with the level select scene
-(void)onePlayerModeSelected
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [DTLevelSelectScene scene] withColor:ccWHITE]];
}

// In this case we scan for another device using gamekit
-(void)twoPlayerModeSelected
{
}

@end







