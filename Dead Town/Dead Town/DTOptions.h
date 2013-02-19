//
//  DTOptions.h
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "CCNode.h"

@interface DTOptions : NSObject

@property(nonatomic) BOOL playSoundEffects;
@property(nonatomic) BOOL playBackgroundMusic;
@property(nonatomic) BOOL useTiltControls;

+(id)sharedOptions;

@end
