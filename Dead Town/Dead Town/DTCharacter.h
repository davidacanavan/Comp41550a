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
@class DTWeapon;

@interface DTCharacter : CCNode
{
    @protected
    DTGameLayer *_gameLayer; // The parent game layer
    DTOptions *_options; // General settings singleton
    CCSprite *_sprite; // The sprite itself
    // The angle a bullet should fire at to be right on target.
    // This is different to the angle the sprite is facing but turnToFacePoint calculates both.
    float _bulletAngle;
    
    // Various animation objects we'll need for the characters.
    CCRepeatForever *_movingAction;
    CCAnimation *_movingAnimation;
    BOOL _isMovingActionRunning;
}

// The amount of life the character has left, it's between 0 and 100.
@property(nonatomic) float life;
// The current weapon of the character
@property(nonatomic) DTWeapon *weapon;
@property(nonatomic) BOOL isPausing;
@property(nonatomic) CGPoint position;

// Member initializer to create the class - this class should only be used as a base class.
-(id)initWithPosition:(CGPoint)position gameLayer:(DTGameLayer *)gameLayer life:(float)life;
// Moves the character's sprite to the given board position.
-(void)moveToPosition:(CGPoint)position;
// Rotates the character's sprite to face the given point.
-(void)turnToFacePosition:(CGPoint)position;
// Sets and gets the character's current board position.
-(CGPoint)getPosition;
-(void)setPosition:(CGPoint)position;
// Call this to request a fire, by default it calls fire on the current weapon.
-(void)fire;
// This is called by charater when initialising to load and setup the various animations we may need for the characters. The returned node is assigned to the local variable _sprite - returns nil by default.
-(CCSprite *)loadSpriteAndAnimations;

// --- Various controllable player methods that are called in response to joystick movements
// or remote 'player two' connections.

// Notifies the character that a movement has started - this is empty by default.
-(void)notifyMovementStart;
// Notifies the character that a movement has ended - this is empty by default.
-(void)notifyMovementEnd;
// Tells the animation what speed to move the player at - empty by default.
-(void)notifyMovementSpeed:(float)speed;

@end





