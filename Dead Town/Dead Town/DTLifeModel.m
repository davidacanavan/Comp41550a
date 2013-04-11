//
//  DTLifeModel.m
//  Dead Town
//
//  Created by David Canavan on 30/03/2013.
//
//

#import "DTLifeModel.h"

@implementation DTLifeModel

+(id)lifeModelWithLife:(float)life lower:(float)lower upper:(float)upper delegate:(id <DTLifeModelDelegate>)delegate character:(DTCharacter *) character
{
    return [[self alloc] initModelWithLife:life lower:lower upper:upper delegate:delegate character:character];
}

-(id)initModelWithLife:(float)life lower:(float)lower upper:(float)upper delegate:(id <DTLifeModelDelegate>)delegate character:(DTCharacter *) character
{
    if (self = [super init])
    {
        if (upper <= lower)
            return nil; // TODO: Is this ok?
        
        _upper = upper;
        _lower = lower;
        self.life = life; // Call the overidden method
        _character = character;
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
        [delegate lifeChangedFrom:old model:self character:_character];
}

-(float)getPercentage
{
    return _life / (_upper - _lower);
}

-(BOOL)isZero
{
    return _life <= _lower;
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






