//
//  DTPlayerStatusLayer.m
//  Dead Town
//
//  Created by David Canavan on 21/02/2013.
//
//

#import "DTStatusLayer.h"
#import "DTLifeNode.h"
#import "HandyFunctions.h"

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
        
        _lifeNode = [DTLifeNode lifeNodeWithSize:CGSizeMake(GOOEY_LIFE_NODE_WIDTH, GOOEY_LIFE_NODE_HEIGHT)];
        _lifeNode.position = ccp(GOOEY_PADDING_LEFT, [CCDirector sharedDirector].winSize.height - GOOEY_PADDING_TOP);
        _lifeNode.percentage = life / (maxLife - minLife);
        [self addChild:_lifeNode];
    }
    
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    // Small bug fix, and it's just for the status layer, not the controls??? TODO: look into this more
    if (_dominantHand == DTDominantHandLeft)
        _lifeNode.position = ccp([CCDirector sharedDirector].winSize.width - _lifeNode.contentSize.width - GOOEY_PADDING_RIGHT,
                                 [CCDirector sharedDirector].winSize.height - GOOEY_PADDING_TOP);
    else
        _lifeNode.position = ccp(GOOEY_PADDING_LEFT, [CCDirector sharedDirector].winSize.height - GOOEY_PADDING_TOP);
}

-(void)setDominantHand:(DTDominantHand)dominantHand
{
    if (dominantHand == _dominantHand)
        return; // No change at all my friends!
    
    if (dominantHand == DTDominantHandLeft)
        _lifeNode.position = ccp([CCDirector sharedDirector].winSize.width - _lifeNode.contentSize.width - GOOEY_PADDING_RIGHT,
                                 [CCDirector sharedDirector].winSize.height - GOOEY_PADDING_TOP);
    else
        _lifeNode.position = ccp(GOOEY_PADDING_LEFT, [CCDirector sharedDirector].winSize.height - GOOEY_PADDING_TOP);

    _dominantHand = dominantHand;
}

@end























