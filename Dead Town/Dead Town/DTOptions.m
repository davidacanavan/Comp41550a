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
        _playBackgroundMusic = YES;
        _playSoundEffects = YES;
    }
    
    return self;
}

@end
