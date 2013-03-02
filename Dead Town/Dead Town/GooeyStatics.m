//
//  GooeyStatics.m
//  Dead Town
//
//  Created by David Canavan on 11/02/2013.
//
//

#import "GooeyStatics.h"

@implementation GooeyStatics

+(CCMenuItemFont *)menuItemWithString:(NSString *)string fontName:(NSString *)fontName target:(id)target selector:(SEL)selector fontSize:(int)fontSize
{
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:string target:target selector:selector];
    [item setFontName:fontName];
    [item setFontSize:fontSize];
    return item;
}

+(CCMenuItemImage *)menuItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector
{
    return [CCMenuItemImage itemWithNormalImage:imageName selectedImage:imageName target:target selector:selector];
}

@end
