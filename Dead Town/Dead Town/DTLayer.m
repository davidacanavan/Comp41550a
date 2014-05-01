//
//  DTLayer.m
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//
//

#import "DTLayer.h"


@implementation DTLayer

+(id)layerWithBackgroundSprite:(CCSprite *)backgroundSprite darkeningFactor:(float)darkeningFactor
{
    return [[self alloc] initWithBackgroundSprite:backgroundSprite darkeningFactor:darkeningFactor];
}

-(id)initWithBackgroundSprite:(CCSprite *)backgroundSprite darkeningFactor:(float)darkeningFactor
{
    if (self = [super init])
    {
        CGSize screen = [[CCDirector sharedDirector] winSize];
        _backgroundSprite = backgroundSprite;
        _backgroundSprite.position = ccp(screen.width / 2, screen.height / 2);
        _backgroundSprite.color = ccc3(255 * (1 - darkeningFactor), 255 * (1 - darkeningFactor), 255 * (1 - darkeningFactor));
        [self addChild:backgroundSprite z:-100]; // Put it waaaaaaay int the background!!!!!!!!!!!!
    }
    
    return self;
}

// http://www.cocos2d-iphone.org/forum/topic/1722/page/4
-(CCSprite *)screenShotAsSprite
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCRenderTexture *texture = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
    [texture begin];
    [self visit];
    [texture end];
    
    CCSprite *sprite = [CCSprite spriteWithTexture:texture.sprite.texture];
    sprite.flipY = YES;
    return sprite;
}

@end
