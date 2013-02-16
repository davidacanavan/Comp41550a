#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ColoredCircleSprite.h"
#import "DTGameLayer.h"

@interface DTBullet : CCNode
{
    @private
    ColoredCircleSprite *_sprite;
    DTGameLayer *_gameLayer;
}

@property(readonly) BOOL isExpired;

+(id)bulletWithPlayerPosition:(CGPoint)playerPosition andAngle:(float)angleOfFire withGameLayer:(DTGameLayer *)gameLayer;
-(void)moveToPoint:(CGPoint)point;

@end