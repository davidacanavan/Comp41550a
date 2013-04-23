//
//  LazerBeamNode.h
//  Dead Town
//
//  Created by David Canavan on 08/04/2013.
//
//

#import "cocos2d.h"

// Default values for properties
#define DEFAULT_DETAIL 25
#define DEFAULT_THICKNESS 2
#define DEFAULT_DISPLACEMENT 10

// Minimum values for properties
#define MINIMUM_DETAIL 10
#define MINIMUM_DISPLACEMENT 5
#define MINIMUM_THICKNESS 2

@class DTCharacter;

@interface DTLazerBeamNode : CCNode

@property(nonatomic, readonly) DTCharacter *origin;
@property(nonatomic, weak) DTCharacter *target;
@property(nonatomic) BOOL isHoldFiring;
@property(nonatomic) float thickness, displacement;
@property(nonatomic) int detail;

+(id)nodeWithOrigin:(DTCharacter *)origin;

@end
