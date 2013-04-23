//
//  DTPausedScene.m
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "DTPausedScene.h"
#import "DTPausedLayer.h"

@implementation DTPausedScene

+(id)scene
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super init])
    {
        DTPausedLayer *layer = [DTPausedLayer node];
        [self addChild:layer];
    }
    
    return self;
}

@end
