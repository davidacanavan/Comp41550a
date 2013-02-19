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
#import "DTControlsLayer.h"
#import "DTMenuScene.h"

@class DTControlsLayer;

@interface DTPausedLayer : CCLayer
{
    @private
    DTGameLayer *_gameLayer;
    DTControlsLayer *_controlsLayer;
}

+(id)pausedLayerWithGameLayer:(DTGameLayer *)gameLayer andControlsLayer:(DTControlsLayer *)controlsLayer;

@end