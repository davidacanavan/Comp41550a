//
//  DTSpeechLayer.m
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DTSpeechLayer.h"
#import "DTSpeechBoxNode.h"

@implementation DTSpeechLayer

+(id)layerWithBackgroundSprite:(CCSprite *)backgroundSprite andText:(NSString *)text
{
    return [[self alloc] initWithBackgroundSprite:backgroundSprite andText:text];
}

-(id)initWithBackgroundSprite:(CCSprite *)backgroundSprite andText:(NSString *)text
{
    if (self = [super init])
    {
        CGSize screen = [[CCDirector sharedDirector] winSize];
        
        DTSpeechBoxNode *node = [DTSpeechBoxNode nodeWithColor:ccc4(100, 0, 0, 0) bounds:CGSizeMake(screen.width / 3, screen.height / 3) padding:4 text:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas non mi ante. Etiam dignissim sodales nibh, et posuere leo rutrum sed. Suspendisse nisl lectus, convallis at eleifend eget, molestie eu nunc."];
        node.position = ccp(screen.width / 2, screen.height / 2);
        [self addChild:node];
    }
    
    return self;
}

@end
