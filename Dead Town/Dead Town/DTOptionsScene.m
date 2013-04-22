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

+(id)scene
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super init])
    {
        DTOptionsLayer *layer = [DTOptionsLayer node];
        [self addChild: layer];
    }
    
    return self;
}

@end
