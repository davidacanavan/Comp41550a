//
//  DTSpeechScene.h
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TextBox.h"

@class TextBoxLayer;

// https://github.com/Panajev/TextBoxLayerSample
@interface DTSpeechScene : CCScene <TextBoxDelegate>
{
    @private
    TextBoxLayer *_textBoxLayer;
}

+(id)sceneWithText:(NSString *)text;
+(id)sceneWithText:(NSString *) text backgroundSprite:(CCSprite *)backgroundSprite darkeningFactor:(float)darkeningFactor;

@end
