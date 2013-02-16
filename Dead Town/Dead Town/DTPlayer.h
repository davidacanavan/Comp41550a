//
//  DTPlayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ColoredCircleSprite.h"
#import "DTGameLayer.h"

@class DTGameLayer;

@interface DTPlayer : CCNode
{
    @private
    DTGameLayer *_gameLayer;
}

@property(nonatomic, strong, readonly) ColoredCircleSprite *sprite;
@property(nonatomic, readonly) CGPoint previousPosition;

+(id)playerWithPlayerAtPoint:(CGPoint)point withGameLayer:(DTGameLayer *)gameLayer;
-(void)movePlayerToPoint:(CGPoint)point;
-(void)turnToFacePoint:(CGPoint)point;
-(void)fire;

@end
