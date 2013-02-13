//
//  DTPlayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DTPlayer : CCNode

// The sprite for the player
@property(nonatomic, strong) CCSprite *sprite;

+(id)initWithPlayerAtPoint:(CGPoint *)point;
-(void)fire;
-(void)turnToFacePoint:(CGPoint *)point;


@end
