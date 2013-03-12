//
//  DTPlayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTCharacter.h"

@class DTGameLayer;

@interface DTPlayer : DTCharacter

+(id)playerAtPosition:(CGPoint)point gameLayer:(DTGameLayer *)gameLayer life:(float)life;

@end
