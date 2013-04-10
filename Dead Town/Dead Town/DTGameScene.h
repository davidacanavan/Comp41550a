//
//  DTGameScene.h
//  Dead Town
//
//  Created by David Canavan on 29/01/2013.
//
//

#import "CCScene.h"

@class DTLevel;

@interface DTGameScene : CCScene
{
    @private
    DTLevel *_level;
}

+(id)sceneWithLevel:(DTLevel *)level;

@end
