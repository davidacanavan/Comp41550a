//
//  DTPausedLayer.m
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import "DTPausedLayer.h"
#import "GooeyStatics.h"

@implementation DTPausedLayer

+(id)layerWithGameLayer:(DTGameLayer *)gameLayer
{
    return [[self alloc] initWithGameLayer:gameLayer];
}

-(id)initWithGameLayer:(DTGameLayer *)gameLayer
{
    if ((self = [super init]))
    {
        _gameLayer = gameLayer;
        
        CGSize screen = [[CCDirector sharedDirector] winSize];
        NSString *fontName = @"Marker Felt";
        
        // Two menu items for one and two player modes
        CCMenuItemFont *resumeMenuItem = [GooeyStatics menuItemWithString:@"Resume" fontName:fontName target:self selector:@selector(resumeItemPressed) fontSize:22];
        CCMenuItemFont *optionsBlockMenuItem = [GooeyStatics menuItemWithString:@"Options" fontName:fontName target:self selector:@selector(optionsItemPressed) fontSize:22];
        CCMenuItemFont *quitMenuItem = [GooeyStatics menuItemWithString:@"Quit" fontName:fontName target:self selector:@selector(quitItemPressed) fontSize:22];
        CCMenu *pausedMenu = [CCMenu menuWithItems:resumeMenuItem, optionsBlockMenuItem, quitMenuItem, nil];
        
        [pausedMenu alignItemsVerticallyWithPadding:5]; // Stack the menu items on top of each other
        [pausedMenu setPosition:ccp(screen.width / 2, screen.height / 2)];
        [self addChild:pausedMenu];
    }
    
    return self;
}

-(void)resumeItemPressed
{
    [_gameLayer unpauseAll];
    [[self parent] removeChild:self cleanup:NO];
}

-(void)optionsItemPressed
{
    
}

-(void)quitItemPressed
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [DTMenuScene scene] withColor:ccWHITE]];
}

@end












