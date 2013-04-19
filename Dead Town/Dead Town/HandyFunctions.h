//
//  GooeyStatics.h
//  Dead Town
//
//  Created by David Canavan on 11/02/2013.
//
//

#import "cocos2d.h"

@interface HandyFunctions : NSObject

+(CCMenuItemFont *)menuItemWithString:(NSString *)string fontName:(NSString *)fontName target:(id)target selector:(SEL)selector fontSize:(int)fontSize;
+(CCMenuItemImage *)menuItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector;
+(void)showAlertDialogEntitled:(NSString *)title withMessage:(NSString *)message;

@end
