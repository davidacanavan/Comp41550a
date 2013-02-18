//
//  DTOptions.h
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import "CCNode.h"

@interface DTOptions : NSObject

@property(nonatomic) BOOL playSoundEffects;
@property(nonatomic) BOOL playBackgroundMusic;

+(id)sharedOptions;

@end
