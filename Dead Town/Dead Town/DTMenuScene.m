//
//  DTMenuScene.m
//  Dead Town
//
//  Created by David Canavan on 29/01/2013.
//
//

#import "DTMenuScene.h"
#import "DTMenuLayer.h"

@implementation DTMenuScene

+(id)scene
{
    return [[[self alloc] init] autorelease];
}

-(id)init
{
    if (self = [super init])
    {
        DTMenuLayer *layer = [DTMenuLayer node];
        [self addChild: layer];
    }
    
    return self;
}

@end
