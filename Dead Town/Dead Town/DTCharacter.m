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


-(void)notifyMovementStart
{
    // A boolean to add extra safety to the calls - in case anything trips over each other
    if (!_isMovingActionRunning)
    {
        [self.sprite runAction:_movingAction];
        _isMovingActionRunning = YES;
    }
}

-(void)notifyMovementSpeed:(float)speed {} // TODO: change the speed with the controller for the player

-(void)notifyMovementEnd
{
    if (_isMovingActionRunning)
    {
        [self.sprite stopAction:_movingAction];
        self.sprite.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_defaultFrameName];
        _isMovingActionRunning = NO;
    }
}

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
    float x, y;
    CGPoint diff = ccpSub(position, current);
    
    // Better check if this isn't too good so we don't get an overflow an can move along the y
    if (fabsf(diff.x) < X_SENSITIVITY)
    {
        x = current.x;
        y = current.y + (diff.y > 0 ? 1 : -1) * movingDistance;
    }
    else
    {
        float slope = ((float) (diff.y)) / (diff.x);
        float c = position.y - slope * position.x; // The y-intercept
        float xComponentFactor = cos(atanf(slope));
        x = current.x + movingDistance * xComponentFactor * (position.x < current.x ? -1 : 1);
        y = slope * x + c;
    }
    
    return ccp(x, y);
}

@end















