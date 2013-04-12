//
//  DTCharacter.m
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "DTCharacter.h"
#import "DTOptions.h"
#import "DTWeapon.h"
#import "DTLifeModel.h"
#import "DTLevel.h"

@implementation DTCharacter

@synthesize position = _position;
@synthesize sprite = _sprite;


-(id)initWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life
     characterType:(DTCharacterType)characterType velocity:(float)velocity
{
    if (self = [super init])
    {
        // Get the options singleton
        _options = [DTOptions sharedOptions];
        
        // Save the instance variables and set the sprite's position
        _level = level;
        _sprite = [self loadSpriteAndAnimations]; // This method is overriden by subclasses to allow more functionality
        _sprite.position = position;
        _lifeModel = [DTLifeModel lifeModelWithLife:life lower:0 upper:life delegate:nil character:self];
        _characterType = characterType;
        _velocity = velocity;
        
        // Add the sprite to the layer
        [self addChild:_sprite];
    }
    
    return self;
}

-(void)moveToPosition:(CGPoint)position
{
    _sprite.position = position;
}

-(void)turnToFacePosition:(CGPoint)position
{
    // If you ever have to go through this nightmare again remember that the cocos2d sprite rotation works with an angle the positive side of the x axis as a positive angle from the easterly side of the x-axis!!!
    CGPoint spritePosition = _sprite.position;
    float xDifference = (float) (position.x - spritePosition.x);
    float tanToHorizontalAxis = (position.y - spritePosition.y) / ((float) xDifference); // (y2 - y1) / (x2 - x1)
    // Get the inverse tan of the ratio. Convert back to degrees. Add 180 to ensure the direction is correct!
    float bulletAngle = CC_RADIANS_TO_DEGREES(atanf(tanToHorizontalAxis));
    float angleValue = -bulletAngle;
    
    if (xDifference < 0)
    {
        bulletAngle += 180;
        angleValue += 180;
    }
    
    _sprite.rotation = angleValue;
    _bulletAngle = bulletAngle;
}

-(CGPoint)getPosition // TODO: I shouldn't need to override this anymore
{
    return _sprite.position;
}

-(void)setPosition:(CGPoint)position
{
    _sprite.position = position;
    _position = position;
}

// Override of the setter to ensure the player's life never goes below 0 or beyond 100.
-(void)setLife:(float)life
{
    _lifeModel.life = life;
}

-(void)notifyMovementStart {}
-(void)notifyMovementEnd {}
-(void)notifyMovementSpeed:(float)speed {}
-(CCNode *)loadSpriteAndAnimations {return nil;}

// By default we just ask the weapon to fire for us.
-(void)fire
{
    BOOL success = [_weapon fireAtAngle:_bulletAngle from:_sprite.position level:_level];
    
    if (success)
        [self onFireSuccess];
}

-(void)onFireSuccess {}

-(BOOL)isHero
{
    return self.characterType == CharacterTypeHero;
}

-(BOOL)isVillian
{
    return self.characterType == CharacterTypeVillian;
}

-(BOOL)isFriendlyWithCharacter:(DTCharacter *)character
{
    return self.characterType == character.characterType;
}

-(void)setWeapon:(DTWeapon *)weapon
{ // TODO: Make sure the owner of the weapon is the character
    if (self.weapon) // Remove the old one
        [self removeChild:_weapon cleanup:NO];
    
    _weapon = weapon; // Add it as a child so we can get the update call
    _weapon.owner = self; // Claim the weapon
    [self addChild:_weapon];
}

-(CGPoint)newPositionTowardsPosition:(CGPoint)position velocity:(float)velocity delta:(float)delta
{
    CGPoint current = self.sprite.position;
    float movingDistance = velocity * delta; // Use a different velocity, this allows for more variation than the constant
    float slope = ((float) (position.y - current.y)) / (position.x - current.x);
    float c = position.y - slope * position.x; // The y-intercept
    float xComponentFactor = cos(atanf(slope));
    float x = current.x + movingDistance * xComponentFactor * (position.x < current.x ? -1 : 1);
    float y = slope * x + c;
    return ccp(x, y);
}

@end















