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
}

-(id)initWithPosition:(CGPoint)position gameLayer:(DTGameLayer *)gameLayer andSprite:(CCNode *)sprite;
-(void)moveToPosition:(CGPoint)position;
-(void)turnToFacePosition:(CGPoint)position;
-(CGPoint)getPosition;

@end
