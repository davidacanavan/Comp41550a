//
//  DTLevelSelectScene.m
//  Dead Town
//
//  Created by David Canavan on 29/01/2013.
//
//

#import "DTLevelSelectScene.h"
#import "DTLevelSelectLayer.h"

@implementation DTLevelSelectScene

+(id)scene
{
    return [[self alloc] init];
}

-(id)init
{
    if (self = [super init])
    {
        DTLevelSelectLayer *layer = [DTLevelSelectLayer node];
        [self addChild:layer];
    }
    
    return self;
}

@end
