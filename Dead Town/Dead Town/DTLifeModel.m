//
//  DTLifeModel.m
//  Dead Town
//
//  Created by David Canavan on 30/03/2013.
//
//

#import "DTLifeModel.h"

@implementation DTLifeModel

+(id)lifeModelWithLife:(float)life lower:(float)lower upper:(float)upper delegate:(id <DTLifeModelDelegate>)delegate
{
    return [[self alloc] initModelWithLife:life lower:lower upper:upper delegate:delegate];
}

-(id)initModelWithLife:(float)life lower:(float)lower upper:(float)upper delegate:(id <DTLifeModelDelegate>)delegate
{
    if (self = [super init])
    {
        if (upper <= lower)
            return nil; // TODO: Is this ok?
        
        _upper = upper;
        _lower = lower;
        self.life = life; // Call the overidden method
        _delegates = [NSMutableArray arrayWithCapacity:3]; // Allocate the array
        
        if (delegate)
            [self addDelegate:delegate];
    }
    
    return self;
}
                     
-(void)setLife:(float)life
{
    float old = _life;
    _life = fmaxf(fminf(life, _upper), _lower); // Bound the range
    
    for (id <DTLifeModelDelegate> delegate in _delegates)
        [delegate lifeChangedFrom:old model:self];
}

-(float)getPercentage
{
    return _life / (_upper - _lower);
}

-(void)addDelegate:(id <DTLifeModelDelegate>)delegate
{
    [_delegates addObject:delegate];
}

-(void)removeDelegate:(id <DTLifeModelDelegate>)delegate
{
    [_delegates removeObject:delegate];
}

@end






