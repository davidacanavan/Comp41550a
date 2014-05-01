//
//  DTOptionsLayer.h
//  Dead Town
//
//  Created by David Canavan on 22/04/2013.
//
//

#import "cocos2d.h"

@class DTOptions;

@interface DTOptionsLayer : CCLayer
{
    @private
    CCMenuItemFont *_musicOn, *_musicOff;
    CCMenuItemFont *_soundFxOn, *_soundFxOff;
    CCMenuItemFont *_contolsJoystick, *_controlsTilt;
    CCMenuItemFont *_handRight, *_handLeft;
    DTOptions *_options;
}

+(id)layerWithBackgroundSprite:(CCSprite *)backgroundSprite;

@end
