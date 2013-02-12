//
//  DTLevelSelectLayer.m
//  Dead Town
//
//  Created by David Canavan on 11/02/2013.
//
//

#import "DTLevelSelectLayer.h"
#import "DTMenuScene.h"
#import "GooeyStatics.h"

@implementation DTLevelSelectLayer

-(id)init
{
    if ((self = [super init]))
    {
        CGSize screen = [[CCDirector sharedDirector] winSize];
        NSString *fontName = @"Marker Felt";
        
        CCMenuItemFont *backButtonMenuItem = [GooeyStatics menuItemWithString:@"Back" fontName:fontName target:self selector:@selector(backSelected) fontSize:22];
        CCMenu *backMenu = [CCMenu menuWithItems:backButtonMenuItem, nil];
        CGSize backMenuSize = [backButtonMenuItem contentSize];
        [backMenu setPosition:ccp(15 + backMenuSize.width / 2, screen.height - backMenuSize.height / 2 - 15)];
        [self addChild:backMenu];
        
        // Two menu items for one and two player modes
        CCMenuItemFont *hospitalMenuItem = [GooeyStatics menuItemWithString:@"Hospital" fontName:fontName target:self selector:@selector(levelSelected:) fontSize:22];
        CCMenuItemFont *officeBlockMenuItem = [GooeyStatics menuItemWithString:@"Office Block" fontName:fontName target:self selector:@selector(levelSelected:) fontSize:22];
        CCMenuItemFont *streetsMenuItem = [GooeyStatics menuItemWithString:@"Streets" fontName:fontName target:self selector:@selector(levelSelected:) fontSize:22];
        CCMenuItemFont *appartmentsMenuItem = [GooeyStatics menuItemWithString:@"Appartments" fontName:fontName target:self selector:@selector(levelSelected:) fontSize:22];
        CCMenu *levelSelectMenu = [CCMenu menuWithItems:hospitalMenuItem, officeBlockMenuItem, streetsMenuItem, appartmentsMenuItem, nil];
        
        [levelSelectMenu alignItemsVerticallyWithPadding:5]; // Stack the menu items on top of each other
        [levelSelectMenu setPosition:ccp(screen.width / 2, screen.height / 2)];
        [self addChild:levelSelectMenu];
    }
    
    return self;
}

// Called when the user chooses a level
-(void)levelSelected:(CCMenu *)menuItem
{
    
}

// Called when the user presses back to go to the main menn
-(void)backSelected
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [DTMenuScene scene] withColor:ccWHITE]];
}

@end









