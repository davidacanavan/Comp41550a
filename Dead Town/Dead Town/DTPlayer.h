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
#import "DTOptions.h"
#import "DTBullet.h"
#import "SimpleAudioEngine.h"

@class DTGameLayer;

@interface DTPlayer : CCNode
{
    @private
    DTGameLayer *_gameLayer;
    DTOptions *_options;
    CCRepeatForever *_movingAction;
    CCAnimation *_movingAnimation;
    BOOL _isMovingActionRunning;
}

@property(nonatomic, strong, readonly) CCSprite *sprite;
@property(nonatomic, readonly) CGPoint previousPosition;
@property(nonatomic, readonly) float bulletAngle;

+(id)playerWithPlayerAtPoint:(CGPoint)point withGameLayer:(DTGameLayer *)gameLayer;
-(void)movePlayerToPoint:(CGPoint)point;
-(void)turnToFacePoint:(CGPoint)point;
-(void)fire;
-(CGPoint)getPosition;
-(void)notifyMovementStart;
-(void)notifyMovementStop;
-(void)notifyMovementSpeed:(float)speed;

@end
