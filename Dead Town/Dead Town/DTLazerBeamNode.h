//
//  LazerBeamNode.h
//  Dead Town
//
//  Created by David Canavan on 08/04/2013.
//
//

#import "cocos2d.h"

@class DTCharacter;

@interface DTLazerBeamNode : CCNode
{
    @private
    float _thickness, _displacement;
    int _detail;
}

@property(nonatomic, readonly) DTCharacter *origin;
@property(nonatomic) DTCharacter *target;

+(id)nodeWithOrigin:(DTCharacter *)origin;

@end
