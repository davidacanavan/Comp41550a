//
//  GooeyStatics.m
//  Dead Town
//
//  Created by David Canavan on 11/02/2013.
//
//

#import "HandyFunctions.h"
#import "UIKit/UIKit.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation HandyFunctions

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

+(void)showAlertDialogEntitled:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+(float)uniformFrom:(float)min to:(float)max
{
    return (((float) arc4random()) / ARC4RANDOM_MAX) * (max - min) + min;
}



@end













