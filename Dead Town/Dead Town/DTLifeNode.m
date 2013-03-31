//
//  DTLifeNode.m
//  Dead Town
//
//  Created by David Canavan on 21/02/2013.
//
//

#import "DTLifeNode.h"
#import "DTLifeModel.h"

@implementation DTLifeNode

+(id)lifeNodeWithRect:(CGRect)rect
{
    return [[self alloc] initWithRect:rect];
}

-(id)initWithRect:(CGRect)rect
{
    if (self = [super init])
    {
        self.contentSize = rect.size;
        self.position = ccp(rect.origin.x + rect.size.width / 2, rect.origin.y - rect.size.height / 2);
        _inset = 0.05 * rect.size.height;
        
        // TODO: No need to recalculate these each time
        CGRect box = self.boundingBox;
        CGPoint insets = ccp(_inset, _inset);
        _topLeft = ccp(-box.size.width / 2, -box.size.height / 2);
        _bottomRight = ccp(box.size.width / 2, box.size.height / 2);
        _topLeftInternal = ccpAdd(_topLeft, insets);
        _bottomRightInternal = ccpSub(_bottomRight, insets);
        _currentLifeInternal = _bottomRightInternal;
        _maxBarLength = ccpSub(_bottomRightInternal, _topLeftInternal).x;
    }
    
    return self;
}

-(void)draw
{
    [super draw];
    ccDrawSolidRect(_topLeft, _bottomRight, ccc4f(0, 0, 255, 255)); // Draw border
    ccDrawSolidRect(_topLeftInternal, _bottomRightInternal, ccc4f(255, 0, 0, 50)); // Fill clear(ish)
    ccDrawSolidRect(_topLeftInternal, _currentLifeInternal, ccc4f(0, 250, 0, 255)); // Fill life
}

-(void)lifeChangedFrom:(float)oldLife model:(DTLifeModel *)lifeModel
{
    CGRect box = self.boundingBox;
    float barLength = [lifeModel getPercentage] * _maxBarLength;
    _currentLifeInternal = ccp(-box.size.width / 2 + _inset + barLength,  _currentLifeInternal.y);
}

@end











