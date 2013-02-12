//
//  DTGameScene.m
//  Dead Town
//
//  Created by David Canavan on 29/01/2013.
//
//

#import "DTGameScene.h"
#import "DTGameLayer.h"

@implementation DTGameScene

+(id)scene
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super init])
    {
        DTGameLayer *gameLayer = [DTGameLayer node];
        [self addChild:gameLayer];
    }
    
    return self;
}

@end
