//
//  DTGameScene.m
//  Dead Town
//
//  Created by David Canavan on 29/01/2013.
//
//

#import "DTGameScene.h"
#import "DTGameLayer.h"
#import "DTControlsLayer.h"
#import "DTPausedLayer.h"
#import "DTStatusLayer.h"
#import "DTLevel.h"

@implementation DTGameScene

+(id)sceneWithLevel:(DTLevel *)level
{
    return [[self alloc] initWithLevel:level];
}

-(id)initWithLevel:(DTLevel *)level
{
    if (self = [super init])
    {
        // So this scene has a few layers to deal with - the controls, info and map layer
        DTStatusLayer *statusLayer = [DTStatusLayer statusLayerWithLife:100 minLife:0 maxLife:100];
        DTGameLayer *gameLayer = [DTGameLayer gameLayerWithStatusLayer:statusLayer];
        DTControlsLayer *controlsLayer = [DTControlsLayer layerWithControllerType:DTControllerTypeJoystick controllerDelegate:level buttonDelegate:level dominantHand:DTDominantHandRight];
        gameLayer.controlsLayer = controlsLayer;
        
        [self addChild:gameLayer z:-1]; // Make sure the map is behind the controls
        [self addChild:controlsLayer];
        [self addChild:statusLayer];
        
        _level = level;
        _level.gameLayer = gameLayer;
    }
    
    return self;
}

@end
