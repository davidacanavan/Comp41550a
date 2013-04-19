//
//  DTGameScene.h
//  Dead Town
//
//  Created by David Canavan on 29/01/2013.
//
//

#import "CCScene.h"
#import "Gamekit/GameKit.h"

@class DTLevel;

@interface DTGameScene : CCScene
{
    @private
    DTLevel *_level; // Keep a strong reference to the level
}

+(id)sceneWithLevel:(DTLevel *)level;

@end
