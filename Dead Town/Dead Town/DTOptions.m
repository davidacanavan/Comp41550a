//
//  DTOptions.m
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import "DTOptions.h"
#import "SimpleAudioEngine.h"

#define PLAY_BACKGROUND_MUSIC @"play_bg"
#define PLAY_SOUND_EFFECTS @"play_fx"
#define CONTROLLER_TYPE @"c_type"
#define DOMINANT_HAND @"dom_hand"

@implementation DTOptions

#pragma mark-
#pragma mark Initialisation

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
            [defaults setInteger:DTControllerTypeJoystick forKey:CONTROLLER_TYPE];
            [defaults setInteger:DTDominantHandRight forKey:DOMINANT_HAND];
            [defaults synchronize];
        }
        
        _canPlayBackgroundMusic = [defaults boolForKey:PLAY_BACKGROUND_MUSIC];
        _canPlaySoundEffects = [defaults boolForKey:PLAY_SOUND_EFFECTS];
        _controllerType = [defaults integerForKey:CONTROLLER_TYPE];
        _dominantHand = [defaults integerForKey:DOMINANT_HAND];
        
        _audioEngine = [SimpleAudioEngine sharedEngine];
    }
    
    return self;
}

#pragma mark-
#pragma mark Sound & Music

-(void)playSoundbyteIfOptionsAllow:(NSString *)name
{
    if (self.canPlaySoundEffects)
        [_audioEngine playEffect:name];
}

-(void)playBackgroundTrackIfOptionsAllow:(NSString *)name onLoop:(BOOL)onLoop
{
    if (self.canPlayBackgroundMusic && !_audioEngine.isBackgroundMusicPlaying)
        [_audioEngine playBackgroundMusic:name loop:onLoop];
}

-(void)stopBackgroundTrackIfOptionsAllow
{
    if (self.canPlayBackgroundMusic && _audioEngine.isBackgroundMusicPlaying)
        [_audioEngine stopBackgroundMusic];
}

-(void)stopBackgroundTrack
{
    [_audioEngine stopBackgroundMusic];
}

#pragma mark-
#pragma mark Property Overrides

-(void)setCanPlayBackgroundMusic:(BOOL)canPlayBackgroundMusic
{
    _canPlayBackgroundMusic = canPlayBackgroundMusic;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:canPlayBackgroundMusic forKey:PLAY_BACKGROUND_MUSIC];
    [defaults synchronize];
}

-(void)setCanPlaySoundEffects:(BOOL)canPlaySoundEffects
{
    _canPlaySoundEffects = canPlaySoundEffects;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:canPlaySoundEffects forKey:PLAY_SOUND_EFFECTS];
    [defaults synchronize];
}

-(void)setControllerType:(DTControllerType)controllerType
{
    _controllerType = controllerType;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:controllerType forKey:CONTROLLER_TYPE];
    [defaults synchronize];
}

-(void)setDominantHand:(DTDominantHand)dominantHand
{
    _dominantHand = dominantHand;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:dominantHand forKey:DOMINANT_HAND];
    [defaults synchronize];
}

@end












