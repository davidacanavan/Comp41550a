#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ColoredCircleSprite.h"
#import "DTGameLayer.h"

@class DTGameLayer;
@class DTCharacter;

@interface DTBullet : CCNode
{
    @private
    // The sprite that actually represents the bullet.
    ColoredCircleSprite *_sprite;
    // The parent game layer which co-ordinates the game.
    DTGameLayer *_gameLayer;
}

// True if the bullet has hit a valid target.
@property(nonatomic, readonly) BOOL isExpired;
// The bullet can only travel this distance before it is destroyed.
// Put in a value of -1 for the bullet to travel until it hits a solid object but otherwise no limiting distance.
@property(nonatomic, readonly) float maxDistance;
// The damage the bullet will cause.
@property(nonatomic, readonly) float damage;
// Whether the bullet belongs to the player or an enemy.
@property(nonatomic, readonly) DTCharacter *owner;
// The initial position of the bullet.
@property(nonatomic, readonly) CGPoint initialPosition;

// Factory method to create the bullet
+(id)bulletWithPosition:(CGPoint)initialPosition andAngle:(float)angleOfFire damage:(float)damage maxDistance:(float)maxDistance owner:(DTCharacter *)owner withGameLayer:(DTGameLayer *)gameLayer;
-(void)moveToPoint:(CGPoint)point;

@end