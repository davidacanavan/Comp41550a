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

@implementation DTGameScene

+(id)scene
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super init])
    {
        // So this scene has a few layers to deal with - the controls, info and map layer
        DTGameLayer *gameLayer = [DTGameLayer node];
        DTControlsLayer *controlsLayer = [DTControlsLayer node];
        [self addChild:gameLayer z:-1]; // Make sure the map is behind the controls
        [self addChild:controlsLayer];
    }
    
    return self;
}

@end
