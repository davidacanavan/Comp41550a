//
//  DTPlayerStatusLayer.m
//  Dead Town
//
//  Created by David Canavan on 21/02/2013.
//
//

#import "DTStatusLayer.h"
#import "DTLifeNode.h"

@implementation DTStatusLayer

+(id)statusLayerWithLife:(float)life minLife:(float)minLife maxLife:(float)maxLife
{
    return [[self alloc] initWithLife:life minLife:minLife maxLife:maxLife];
}

-(id)initWithLife:(float)life minLife:(float)minLife maxLife:(float)maxLife
{
    if (self = [super init])
    {
        _life = life;
        _minLife = minLife;
        _maxLife = maxLife;
        int padding = 15, width = 160, height = 20;
        CGSize screen = [CCDirector sharedDirector].winSize;
        _lifeNode = [DTLifeNode lifeNodeWithRect:CGRectMake(padding, screen.height - padding, width, height)];
        _lifeNode.percentage = life / (maxLife - minLife);
        [self addChild:_lifeNode];
    }
    
    return self;
}

@end
