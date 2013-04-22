//
//  DTOptions.h
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTControlsLayerConstants.h"

@interface DTOptions : NSObject

@property(nonatomic) BOOL playSoundEffects;
@property(nonatomic) BOOL playBackgroundMusic;
@property(nonatomic) ControllerType controllerType;
@property(nonatomic) DominantHand dominantHand;

+(id)sharedOptions;

@end
