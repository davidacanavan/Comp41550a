//
//  DTOptions.h
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTGuiTypes.h"

@class SimpleAudioEngine;

@interface DTOptions : NSObject
{
    @private
    SimpleAudioEngine *_audioEngine;
}

@property(nonatomic) BOOL canPlaySoundEffects;
@property(nonatomic) BOOL canPlayBackgroundMusic;
@property(nonatomic) DTControllerType controllerType;
@property(nonatomic) DTDominantHand dominantHand;

+(id)sharedOptions;
-(void)playSoundbyteIfOptionsAllow:(NSString *)name;
-(void)playBackgroundTrackIfOptionsAllow:(NSString *)name onLoop:(BOOL)onLoop;
-(void)stopBackgroundTrackIfOptionsAllow;
-(void)stopBackgroundTrack;

@end
