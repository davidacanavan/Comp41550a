//
//  DTOptionsScene.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTOptionsScene.h"
#import "DTOptionsLayer.h"

@implementation DTOptionsScene

+(id)sceneWithBackgroundSprite:(CCSprite *)backgroundSprite;
{
    return [[self alloc] initWithBackgroundSprite:backgroundSprite];
}

-(id)initWithBackgroundSprite:(CCSprite *)backgroundSprite;
{
    if (self = [super init])
    {
        DTOptionsLayer *layer = [DTOptionsLayer layerWithBackgroundSprite:backgroundSprite];
        [self addChild: layer];
    }
    
    return self;
}

@end
