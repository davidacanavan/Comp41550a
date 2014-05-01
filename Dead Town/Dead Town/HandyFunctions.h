//
//  GooeyStatics.h
//  Dead Town
//
//  Created by David Canavan on 11/02/2013.
//
//

#import "cocos2d.h"
#import "DTGuiTypes.h"

@interface HandyFunctions : NSObject

+(CCMenuItemFont *)menuItemWithString:(NSString *)string fontName:(NSString *)fontName target:(id)target selector:(SEL)selector fontSize:(int)fontSize;
+(CCMenuItemFont *)menuItemWithString:(NSString *)string fontName:(NSString *)fontName fontSize:(int)fontSize;
+(CCMenuItemToggle *)toggleMenuItemWithTitle:(NSString *)title1 title:(NSString *)title2 target:(id)target selector:(SEL)selector fontName:(NSString *)fontName fontSize:(int)fontSize;
+(CCMenuItemImage *)menuItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector;
+(void)showAlertDialogEntitled:(NSString *)title withMessage:(NSString *)message;
+(float)uniformFrom:(float)min to:(float)max;
+(void)layoutNode:(CCNode *)node toCorner:(DTLayoutCorner)corner leftPadding:(float)leftPadding rightPadding:(float)rightPadding topPadding:(float)topPadding bottomPadding:(float)bottomPadding;
+(void)layoutNodeFromGooeyConstants:(CCNode *)node toCorner:(DTLayoutCorner)corner;
+(void)showTextBoxWithText:(NSString *)text fromLayer:(CCLayer *)layer;

@end
