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
        
        CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"dt_intro_background.png"];
        backgroundSprite.position = ccp(screen.width / 2, screen.height / 2);
        [self addChild: backgroundSprite z:-1];
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"dt_intro_title_0.png"];
        titleSprite.position = ccp(screen.width / 2, screen.height * 0.67);
        [self addChild: titleSprite z:1];
        
        //[self initHeadingAnimation];
        //_headingSprite.position = ccp(screen.width / 2, screen.height / 2);
        //[self addChild:_headingSprite];
        
        CCMenuItemImage *onePlayerMenuItem = [GooeyStatics menuItemWithImageName:@"dt_intro_one_player.png" target:self selector:@selector(onePlayerModeSelected)];
        CCMenuItemImage *twoPlayerMenuItem = [GooeyStatics menuItemWithImageName:@"dt_intro_two_player.png" target:self selector:@selector(twoPlayerModeSelected)];
        
        CCMenu *menu = [CCMenu menuWithItems:onePlayerMenuItem, twoPlayerMenuItem, nil];
        [menu alignItemsHorizontallyWithPadding:40];
        menu.position = ccp(screen.width / 2, screen.height * .35);
        [self addChild:menu z:2];
    }
    
    return self;
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







