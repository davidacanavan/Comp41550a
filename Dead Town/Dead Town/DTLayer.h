//
//  DTLayer.h
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//
//

#import "cocos2d.h"

@interface DTLayer : CCLayer

@property(nonatomic) CCSprite *backgroundSprite;

+(id)layerWithBackgroundSprite:(CCSprite *)backgroundSprite darkeningFactor:(float)darkeningFactor;
-(id)initWithBackgroundSprite:(CCSprite *)backgroundSprite darkeningFactor:(float)darkeningFactor;

-(CCSprite *)screenShotAsSprite;

@end
