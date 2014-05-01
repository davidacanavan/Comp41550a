//
//  DTPausedScene.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTPausedScene.h"
#import "DTPausedLayer.h"
#import "CCRenderTexture.h"
#import "CCSprite.h"

@implementation DTPausedScene

+(id)sceneWithBackgroundSprite:(CCSprite *)backgroundSprite
{
    return [[self alloc] initWithBackgroundSprite:backgroundSprite];
}

-(id)initWithBackgroundSprite:(CCSprite *)backgroundSprite
{
    if (self = [super init])
    {
        DTPausedLayer *layer = [DTPausedLayer layerWithBackgroundSprite:backgroundSprite];
        [self addChild:layer];
    }
    
    return self;
}

@end
