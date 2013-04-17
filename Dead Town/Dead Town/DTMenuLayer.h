//
//  DTMenuLayer.h
//  Dead Town
//
//  Created by David Canavan on 10/02/2013.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface DTMenuLayer : CCLayer
{
    @private
    CCSprite *_headingSprite;  
    CCAnimate *_headingAnimation;
    CCSprite *_titleSprite;
    CCMenu *_menu;
}

@end
