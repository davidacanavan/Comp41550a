//
//  DTCharacter.h
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "cocos2d.h"

@class DTGameLayer;
@class DTOptions;

@interface DTCharacter : CCNode
{
    @protected
    DTGameLayer *_gameLayer; // The parent game layer
    DTOptions *_options; // General settings singleton
    CCNode *_sprite; // The sprite itself
    CGPoint _previousPosition; // The position the sprite was in before this call to the game loop (for walls)
    float _bulletAngle; // The angle a bullet should fire at to be right on target
    float _maxAttackRate;
    float _currentFireGap;
}

@property(nonatomic) float life;
@property(nonatomic) BOOL isPausing;

-(id)initWithPosition:(CGPoint)position gameLayer:(DTGameLayer *)gameLayer sprite:(CCNode *)sprite life:(float)life maxAttacksPerSecond:(int)maxAttacksPerSecond;
-(void)moveToPosition:(CGPoint)position;
-(void)turnToFacePosition:(CGPoint)position;
-(CGPoint)getPosition;

@end
