//
//  DTPlayerStatusLayer.m
//  Dead Town
//
//  Created by David Canavan on 21/02/2013.
//
//

#import "DTPlayerStatusLayer.h"

@implementation DTPlayerStatusLayer

@synthesize life = _life;
@synthesize maxLife = _maxLife;
@synthesize minLife = _minLife;


+(id)playerStatusLayerWithLife:(float)life minLife:(float)minLife maxLife:(float)maxLife
{
    return [[self alloc] initWithLife:life minLife:minLife maxLife:maxLife];
}

-(id)initWithLife:(float)life minLife:(float)minLife maxLife:(float)maxLife
{
    if (self = [super init])
    {
        _life = life;
        _minLife = _minLife;
        _maxLife = maxLife;
    }
    
    return self;
}

@end
