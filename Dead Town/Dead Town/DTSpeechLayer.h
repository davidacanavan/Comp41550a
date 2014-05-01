//
//  DTSpeechLayer.h
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DTSpeechLayer : CCLayer

+(id)layerWithBackgroundSprite:(CCSprite *)backgroundSprite andText:(NSString *)text;

@end
