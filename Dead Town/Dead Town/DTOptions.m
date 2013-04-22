//
//  DTOptions.m
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import "DTOptions.h"

#define PLAY_BACKGROUND_MUSIC @"play_bg"
#define PLAY_SOUND_EFFECTS @"play_fx"
#define CONTROLLER_TYPE @"c_type"
#define DOMINANT_HAND @"dom_hand"

@implementation DTOptions

+(id)sharedOptions
{
    static DTOptions *_optionsSingleton;
    
    @synchronized(self)
    {
        if (!_optionsSingleton)
            _optionsSingleton = [[DTOptions alloc] init];
            
        return _optionsSingleton;
    }
}

-(id)init
{
    if (self = [super init])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Check to see if this is a first run or not
        if (![defaults valueForKey:PLAY_BACKGROUND_MUSIC])
        {
            [defaults setBool:YES forKey:PLAY_BACKGROUND_MUSIC];
            [defaults setBool:YES forKey:PLAY_SOUND_EFFECTS];
            [defaults setInteger:ControllerTypeJoystick forKey:CONTROLLER_TYPE];
            [defaults setInteger:DominantHandRight forKey:DOMINANT_HAND];
            [defaults synchronize];
        }
        
        _playBackgroundMusic = [defaults boolForKey:PLAY_BACKGROUND_MUSIC];
        _playSoundEffects = [defaults boolForKey:PLAY_SOUND_EFFECTS];
        _controllerType = [defaults integerForKey:CONTROLLER_TYPE];
        _dominantHand = [defaults integerForKey:DOMINANT_HAND];
    }
    
    return self;
}

-(void)setPlayBackgroundMusic:(BOOL)playBackgroundMusic
{
    _playBackgroundMusic = playBackgroundMusic;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:playBackgroundMusic forKey:PLAY_BACKGROUND_MUSIC];
    [defaults synchronize];
}

-(void)setPlaySoundEffects:(BOOL)playSoundEffects
{
    _playSoundEffects = playSoundEffects;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:playSoundEffects forKey:PLAY_SOUND_EFFECTS];
    [defaults synchronize];
}

-(void)setControllerType:(ControllerType)controllerType
{
    _controllerType = controllerType;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:controllerType forKey:CONTROLLER_TYPE];
    [defaults synchronize];
}

-(void)setDominantHand:(DominantHand)dominantHand
{
    _dominantHand = dominantHand;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:dominantHand forKey:DOMINANT_HAND];
    [defaults synchronize];
}

@end












