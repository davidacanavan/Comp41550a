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

@interface DTPlayer : CCNode
{
    @private
    CCLayer *_parent;
}

@property(nonatomic, strong, readonly) ColoredCircleSprite *sprite;

+(id)initWithPlayerAtPoint:(CGPoint)point parentLayer:(CCLayer *)parent;
-(void)movePlayerToPoint:(CGPoint)point;
-(void)turnToFacePoint:(CGPoint)point;
-(void)fire;

@end
