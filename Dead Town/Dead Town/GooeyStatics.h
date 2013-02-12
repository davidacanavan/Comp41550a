//
//  GooeyStatics.h
//  Dead Town
//
//  Created by David Canavan on 11/02/2013.
//
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface GooeyStatics : NSObject

+(CCMenuItemFont *)menuItemWithString:(NSString *)string fontName:(NSString *)fontName target:(id)target selector:(SEL)selector fontSize:(int)fontSize;

@end
