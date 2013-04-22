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
#import "DTControlsLayerConstants.h"

@implementation DTOptionsLayer

-(id)init
{
    if (self = [super init])
    {
        _options = [DTOptions sharedOptions];
        
        CGSize screen = [[CCDirector sharedDirector] winSize];
        NSString *fontName = @"Marker Felt";
        int fontSize = 22;
        [self allocateMenuItemsWithFontName:fontName andFontSize:fontSize]; // Create the individual menu items themselves
        
        CCMenuItemToggle *musicToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForMusicHit:) items:_musicOn, _musicOff, nil];
        musicToggle.selectedIndex = _options.playBackgroundMusic ? 0 : 1;
        
        CCMenuItemToggle *soundFxToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForSoundFxHit:) items:_soundFxOn, _soundFxOff, nil];
        soundFxToggle.selectedIndex = _options.playSoundEffects ? 0 : 1;
        
        CCMenuItemToggle *controlsToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForControlsHit:) items:_contolsJoystick, _controlsTilt, nil];
        controlsToggle.selectedIndex = _options.controllerType == ControllerTypeJoystick ? 0 : 1;
        
        CCMenuItemToggle *handToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleForHandHit:) items:_handRight, _handLeft, nil];
        handToggle.selectedIndex = _options.dominantHand == DominantHandRight ? 0 : 1;
        
        CCMenuItemFont *resumeButton = [HandyFunctions menuItemWithString:@"resume" fontName:fontName target:self selector:@selector(resumeButtonHit) fontSize:fontSize];
        
        CCMenu *menu = [CCMenu menuWithItems:musicToggle, soundFxToggle, controlsToggle, handToggle, resumeButton, nil];
        
        [menu alignItemsVerticallyWithPadding:5]; // Stack the menu items on top of each other
        [menu setPosition:ccp(screen.width / 2, screen.height / 2)]; // Center them on the screen
        [self addChild:menu];
    }
    
    return self;
}

-(void)allocateMenuItemsWithFontName:(NSString *)fontName andFontSize:(int)fontSize
{
    _musicOn = [HandyFunctions menuItemWithString:@"Music: On" fontName:fontName fontSize:fontSize];
    _musicOff = [HandyFunctions menuItemWithString:@"Music: Off" fontName:fontName fontSize:fontSize];
    _soundFxOn = [HandyFunctions menuItemWithString:@"Sound FX: On" fontName:fontName fontSize:fontSize];
    _soundFxOff = [HandyFunctions menuItemWithString:@"Sound FX: Off" fontName:fontName fontSize:fontSize];
    _contolsJoystick = [HandyFunctions menuItemWithString:@"Controls: Joystick" fontName:fontName fontSize:fontSize];
    _controlsTilt = [HandyFunctions menuItemWithString:@"Controls: Tilt" fontName:fontName fontSize:fontSize];
    _handRight = [HandyFunctions menuItemWithString:@"Hand: Right" fontName:fontName fontSize:fontSize];
    _handLeft = [HandyFunctions menuItemWithString:@"Hand: Left" fontName:fontName fontSize:fontSize];
}

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

-(void)resumeButtonHit
{
    [[CCDirector sharedDirector] popScene];
}

@end
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                                  
