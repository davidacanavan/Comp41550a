//
//  DTCharacter.h
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "cocos2d.h"

#define X_SENSITIVITY 0.05

@class DTLevel;
@class DTOptions;
@class DTWeapon;
@class DTLifeModel;

typedef enum {CharacterTypeHero, CharacterTypeVillian} DTCharacterType;

@interface DTCharacter : CCNode
{
    @protected
    DTLevel *_level; // The parent game layer
    DTOptions *_options; // General settings singleton
    // The angle a bullet should fire at to be right on target.
    // This is different to the angle the sprite is facing but turnToFacePoint calculates both.
    float _bulletAngle, _velocity;
    
    // Various animation objects we'll need for the characters.
    CCRepeatForever *_movingAction;
    CCAnimation *_movingAnimation;
    BOOL _isMovingActionRunning;
    NSString *_defaultFrameName;
}

// The current weapon of the character
@property(nonatomic) DTWeapon *weapon;
@property(nonatomic) BOOL isPausing;
@property(nonatomic) CGPoint position;
@property(nonatomic, readonly) DTLifeModel *lifeModel;
@property(nonatomic, readonly) DTCharacterType characterType;
@property(nonatomic, readonly) CCSprite *sprite;
@property(nonatomic, readonly) BOOL firesVisibleProjectile;

// Member initializer to create the class - this class should only be used as a base class.
-(id)initWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life
characterType:(DTCharacterType)characterType velocity:(float)velocity;
// Moves the character's sprite to the given board position.
-(void)moveToPosition:(CGPoint)position;
// Rotates the character's sprite to face the given point.
-(void)turnToFacePosition:(CGPoint)position;
// Sets and gets the character's current board position.
-(CGPoint)getPosition;
-(void)setPosition:(CGPoint)position;
// Call this to request a fire, by default it calls fire on the current weapon.
-(void)fire;
// This is called by charater when initialising to load and setup the various animations we may need for the characters. The returned node is assigned to the local variable _sprite - returns nil by default. Also set _defaultFrameName - TODO: Put this in the constructor
-(CCSprite *)loadSpriteAndAnimations;
-(BOOL)isHero;
-(BOOL)isVillian;
-(BOOL)isFriendlyWithCharacter:(DTCharacter *)character;
-(void)onFireSuccess;
-(CGPoint)newPositionTowardsPosition:(CGPoint)position velocity:(float)velocity  delta:(float)delta;


// --- Various controllable player methods that are called in response to joystick movements
// or remote 'player two' connections.

// Notifies the character that a movement has started - this is empty by default.
-(void)notifyMovementStart;
// Notifies the character that a movement has ended - this is empty by default.
-(void)notifyMovementEnd;
// Tells the animation what speed to move the player at - empty by default.
-(void)notifyMovementSpeed:(float)speed;
//-(void)notifyHoldFireStop;

@end





