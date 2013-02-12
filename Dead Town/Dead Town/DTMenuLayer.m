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
        NSString *fontName = @"Marker Felt";
        
        // The title label - replace this later with a proper image
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"DEAD TOWN" fontName:fontName fontSize:60];
        [titleLabel setColor:ccRED];
        [titleLabel setPosition:ccp(screen.width / 2, screen.height / 2 + 30)];
        [self addChild: titleLabel];
        
        // Two menu items for one and two player modes
        CCMenuItemFont *onePlayerMenuItem = [GooeyStatics menuItemWithString:@"One Player" fontName:fontName target:self selector:@selector(onePlayerModeSelected) fontSize:22];
        CCMenuItemFont *twoPlayerMenuItem = [GooeyStatics menuItemWithString:@"Two Player" fontName:fontName target:self selector:@selector(twoPlayerModeSelected) fontSize:22];
        CCMenu *menu = [CCMenu menuWithItems:onePlayerMenuItem, twoPlayerMenuItem, nil];
        [menu alignItemsVerticallyWithPadding:5]; // Stack the menu items on top of each other
        [menu setPosition:ccp(screen.width / 2, screen.height / 3)];
        [self addChild:menu];
    }
    
    return self;
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







