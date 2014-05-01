//
//  DTMenuScene.m
//  Dead Town
//
//  Created by David Canavan on 29/01/2013.
//
//

#import "DTIntroScene.h"
#import "DTIntroLayer.h"

@implementation DTIntroScene

+(id)scene
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super init])
    {
        DTIntroLayer *layer = [DTIntroLayer node];
        [self addChild: layer];
    }
    
    return self;
}

@end












