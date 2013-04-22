//
//  DTOptionsLayer.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTOptionsLayer.h"
#import "HandyFunctions.h"

@implementation DTOptionsLayer

-(id)init
{
    if (self = [super init])
    {
        CGSize screen = [[CCDirector sharedDirector] winSize];
        NSString *fontName = @"Marker Felt";
        int fontSize = 22;
        
        CCMenuItemToggle *musicToggle = [HandyFunctions toggleMenuItemWithTitle:@"Music: On" title:@"Music: Off" target:self selector:@selector(toggleForMusicHit:) fontName:fontName fontSize:fontSize];
        
        CCMenuItemToggle *soundFxToggle = [HandyFunctions toggleMenuItemWithTitle:@"Sound FX: On" title:@"Sound FX: Off" target:self selector:@selector(toggleForSoundFxHit:) fontName:fontName fontSize:fontSize];
        
        CCMenuItemToggle *controlsToggle = [HandyFunctions toggleMenuItemWithTitle:@"Controls: Joystick" title:@"Controls: Tilt" target:self selector:@selector(toggleForControlsHit:) fontName:fontName fontSize:fontSize];
        
        CCMenuItemToggle *handToggle = [HandyFunctions toggleMenuItemWithTitle:@"Hand: Left" title:@"Hand: Right" target:self selector:@selector(toggleForHandHit:) fontName:fontName fontSize:fontSize];
        
        CCMenu *menu = [CCMenu menuWithItems:musicToggle, soundFxToggle, controlsToggle, handToggle, nil];
        
        [menu alignItemsVerticallyWithPadding:5]; // Stack the menu items on top of each other
        [menu setPosition:ccp(screen.width / 2, screen.height / 2)]; // Center them on the screen
        [self addChild:menu];
    }
    
    return self;
}

-(void)toggleForMusicHit:(CCMenuItemToggle *)toggle
{
}

-(void)toggleForSoundFxHit:(CCMenuItemToggle *)toggle
{
    
}

-(void)toggleForControlsHit:(CCMenuItemToggle *)toggle
{
    
}

-(void)toggleForHandHit:(CCMenuItemToggle *)toggle
{
    
}

@end
