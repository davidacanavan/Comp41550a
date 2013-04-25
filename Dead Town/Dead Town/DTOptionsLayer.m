//
//  DTOptionsLayer.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTOptionsLayer.h"
#import "HandyFunctions.h"
#import "DTOptions.h"
#import "DTGuiTypes.h"

@implementation DTOptionsLayer

-(id)init
{
    if (self = [super init])
    {
        _options = [DTOptions sharedOptions];
        CGSize screen = [[CCDirector sharedDirector] winSize];
        
        [self allocateMenuItemsWithFontName]; // Create the individual menu items themselves
        
        CCMenuItemToggle *musicToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForMusicHit:) items:_musicOn, _musicOff, nil];
        musicToggle.selectedIndex = _options.playBackgroundMusic ? 0 : 1;
        
        CCMenuItemToggle *soundFxToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForSoundFxHit:) items:_soundFxOn, _soundFxOff, nil];
        soundFxToggle.selectedIndex = _options.playSoundEffects ? 0 : 1;
        
        CCMenuItemToggle *controlsToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForControlsHit:) items:_contolsJoystick, _controlsTilt, nil];
        controlsToggle.selectedIndex = _options.controllerType == ControllerTypeJoystick ? 0 : 1;
        
        CCMenuItemToggle *handToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForHandHit:) items:_handRight, _handLeft, nil];
        handToggle.selectedIndex = _options.dominantHand == DominantHandRight ? 0 : 1;
        
        CCMenuItemFont *resumeButton = [HandyFunctions menuItemWithString:@"Back" fontName:GOOEY_FONT_NAME target:self selector:@selector(backButtonHit) fontSize:GOOEY_FONT_SIZE];
        
        CCMenu *menu = [CCMenu menuWithItems:musicToggle, soundFxToggle, controlsToggle, handToggle, resumeButton, nil];
        
        [menu alignItemsVerticallyWithPadding:5]; // Stack the menu items on top of each other
        [menu setPosition:ccp(screen.width / 2, screen.height / 2)]; // Center them on the screen
        [self addChild:menu];
    }
    
    return self;
}

-(void)allocateMenuItemsWithFontName
{
    _musicOn = [HandyFunctions menuItemWithString:@"Music: On" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
    _musicOff = [HandyFunctions menuItemWithString:@"Music: Off" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
    _soundFxOn = [HandyFunctions menuItemWithString:@"Sound FX: On" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
    _soundFxOff = [HandyFunctions menuItemWithString:@"Sound FX: Off" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
    _contolsJoystick = [HandyFunctions menuItemWithString:@"Controls: Joystick" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
    _controlsTilt = [HandyFunctions menuItemWithString:@"Controls: Tilt" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
    _handRight = [HandyFunctions menuItemWithString:@"Hand: Right" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
    _handLeft = [HandyFunctions menuItemWithString:@"Hand: Left" fontName:GOOEY_FONT_NAME fontSize:GOOEY_FONT_SIZE];
}

#pragma mark-
#pragma mark Button Selectors

-(void)toggleForMusicHit:(CCMenuItemToggle *)toggle
{
    _options.playBackgroundMusic = toggle.selectedItem == _musicOn;
}

-(void)toggleForSoundFxHit:(CCMenuItemToggle *)toggle
{
    _options.playSoundEffects = toggle.selectedItem == _soundFxOn;
}

-(void)toggleForControlsHit:(CCMenuItemToggle *)toggle
{
    if (toggle.selectedItem == _contolsJoystick)
        _options.controllerType = ControllerTypeJoystick;
    else
        _options.controllerType = ControllerTypeTilt;
}

-(void)toggleForHandHit:(CCMenuItemToggle *)toggle
{
    if (toggle.selectedItem == _handRight)
        _options.controllerType = ControllerTypeJoystick;
    else
        _options.controllerType = ControllerTypeTilt;
}

-(void)backButtonHit
{
    [[CCDirector sharedDirector] popScene];
}

@end
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
