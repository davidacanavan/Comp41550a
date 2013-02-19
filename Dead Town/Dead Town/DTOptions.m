//
//  DTOptions.m
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import "DTOptions.h"

@implementation DTOptions

@synthesize playBackgroundMusic = _playBackgroundMusic;
@synthesize playSoundEffects = _playSoundEffects;
@synthesize useTiltControls = _useTiltControls;

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
        if (![defaults valueForKey:@"play_background_music"])
        {
            [defaults setBool:YES forKey:@"play_background_music"];
            [defaults setBool:YES forKey:@"play_sound_effects"];
            [defaults synchronize];
        }
        
     _playBackgroundMusic = [defaults boolForKey:@"play_background_music"];
     _playSoundEffects = [defaults boolForKey:@"play_sound_effects"];
    }
    
    return self;
}

-(void)setPlayBackgroundMusic:(BOOL)playBackgroundMusic
{
    _playBackgroundMusic = playBackgroundMusic;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:playBackgroundMusic forKey:@"play_background_music"];
    [defaults synchronize];
}

-(void)setPlaySoundEffects:(BOOL)playSoundEffects
{
    _playSoundEffects = playSoundEffects;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:playSoundEffects forKey:@"play_sound_effects"];
    [defaults synchronize];
}

@end












