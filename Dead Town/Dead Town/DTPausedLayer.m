//
//  DTPausedLayer.m
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import "DTPausedLayer.h"
#import "HandyFunctions.h"
#import "DTOptionsScene.h"

@implementation DTPausedLayer

+(id)layerWithBackgroundSprite:(CCSprite *)backgroundSprite
{
    return [[self alloc] initWithBackgroundSprite:backgroundSprite];
}

-(id)initWithBackgroundSprite:(CCSprite *)backgroundSprite
{
    if ((self = [super init]))
    {
        CGSize screen = [[CCDirector sharedDirector] winSize];
        NSString *fontName = @"Marker Felt";
        
        // Two menu items for one and two player modes
        CCMenuItemFont *resumeMenuItem = [HandyFunctions menuItemWithString:@"Resume" fontName:fontName target:self selector:@selector(resumeItemPressed) fontSize:22];
        CCMenuItemFont *optionsBlockMenuItem = [HandyFunctions menuItemWithString:@"Options" fontName:fontName target:self selector:@selector(optionsItemPressed) fontSize:22];
        CCMenuItemFont *quitMenuItem = [HandyFunctions menuItemWithString:@"Quit" fontName:fontName target:self selector:@selector(quitItemPressed) fontSize:22];
        CCMenu *pausedMenu = [CCMenu menuWithItems:resumeMenuItem, optionsBlockMenuItem, quitMenuItem, nil];
        
        [pausedMenu alignItemsVerticallyWithPadding:5]; // Stack the menu items on top of each other
        [pausedMenu setPosition:ccp(screen.width / 2, screen.height / 2)];
        [self addChild:pausedMenu];
        
        // Add the background image
        _backgroundSprite = backgroundSprite;
    }
    
    return self;
}

-(void)onEnter
{
    [super onEnter];
    CGSize screen = [[CCDirector sharedDirector] winSize];
    _backgroundSprite.position = ccp(screen.width / 2, screen.height / 2);
    _backgroundSprite.color = ccc3(70, 70, 70); // Lets shade it a bit
    [self addChild:_backgroundSprite z:-1];
}

#pragma mark-
#pragma mark Button Selectors

-(void)resumeItemPressed
{
    [[CCDirector sharedDirector] popScene];
}

-(void)optionsItemPressed
{
    CCDirector *director = [CCDirector sharedDirector];
    [_backgroundSprite removeFromParentAndCleanup:NO]; // So we don't have this added twice
    [director pushScene: [DTOptionsScene sceneWithBackgroundSprite:_backgroundSprite]];
}

-(void)quitItemPressed
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [DTIntroScene scene] withColor:ccWHITE]];
}

@end












