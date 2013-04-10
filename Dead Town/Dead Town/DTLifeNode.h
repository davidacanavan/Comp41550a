//
//  DTLifeNode.h
//  Dead Town
//
//  Created by David Canavan on 21/02/2013.
//
//

#import "cocos2d.h"
#import "DTLifeModelDelegate.h"

@interface DTLifeNode : CCNode <DTLifeModelDelegate>
{
    @private // Layout/drawing variables
    CGPoint _bottomRight;
    CGPoint _topLeftInternal, _bottomRightInternal;
    CGPoint _currentLifeInternal;
    float _inset, _maxBarLength;
}

@property(nonatomic) float percentage;

+(id)lifeNodeWithRect:(CGRect)rect;

@end
