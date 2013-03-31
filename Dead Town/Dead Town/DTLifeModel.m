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
    }
    
    return self;
}
                     
-(void)setLife:(float)life
{
    float old = _life;
    _life = fmaxf(fminf(life, _upper), _lower); // Bound the range
    [_delegate lifeChangedFrom:old model:self];
}

-(float)getPercentage
{
    return _life / (_upper - _lower);
}

@end
