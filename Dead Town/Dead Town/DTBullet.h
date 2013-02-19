#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ColoredCircleSprite.h"
#import "DTGameLayer.h"

@class DTGameLayer;

@interface DTBullet : CCNode
{
    @private
    ColoredCircleSprite *_sprite;
    DTGameLayer *_gameLayer;
}

@property(nonatomic, readonly) BOOL isExpired;

+(id)bulletWithPlayerPosition:(CGPoint)playerPosition andAngle:(float)angleOfFire withGameLayer:(DTGameLayer *)gameLayer;
-(void)moveToPoint:(CGPoint)point;

@end