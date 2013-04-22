//
//  DTPausedLayer.h
//  Dead Town
//
//  Created by David Canavan on 18/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DTGameLayer.h"
#import "DTIntroScene.h"

@class DTControlsLayer;

@interface DTPausedLayer : CCLayer
{
    @private
    DTGameLayer *_gameLayer;
}

+(id)layerWithGameLayer:(DTGameLayer *)gameLayer;

@end
