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

#pragma mark-
#pragma mark Menu Items

+(CCMenuItemFont *)menuItemWithString:(NSString *)string fontName:(NSString *)fontName target:(id)target selector:(SEL)selector fontSize:(int)fontSize
{
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:string target:target selector:selector];
    [item setFontName:fontName];
    [item setFontSize:fontSize];
    return item;
}

+(CCMenuItemFont *)menuItemWithString:(NSString *)string fontName:(NSString *)fontName fontSize:(int)fontSize
{
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:string target:nil selector:nil];
    [item setFontName:fontName];
    [item setFontSize:fontSize];
    return item;
}

+(CCMenuItemToggle *)toggleMenuItemWithTitle:(NSString *)title1 title:(NSString *)title2 target:(id)target selector:(SEL)selector fontName:(NSString *)fontName fontSize:(int)fontSize
{
    CCMenuItemToggle *toggle = [CCMenuItemToggle itemWithTarget:target selector:selector
        items:[HandyFunctions menuItemWithString:title1 fontName:fontName fontSize:fontSize],
              [HandyFunctions menuItemWithString:title1 fontName:fontName fontSize:fontSize],
                                nil];
    return toggle;
}

+(CCMenuItemImage *)menuItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector
{
    return [CCMenuItemImage itemWithNormalImage:imageName selectedImage:imageName target:target selector:selector];
}

#pragma mark-
#pragma mark Alert Dialog

+(void)showAlertDialogEntitled:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark-
#pragma mark Random Numbers

+(float)uniformFrom:(float)min to:(float)max
{
    return (((float) arc4random()) / ARC4RANDOM_MAX) * (max - min) + min;
}

#pragma mark-
#pragma mark Layout Functions

+(void)layoutNode:(CCNode *)node toCorner:(DTLayoutCorner)corner leftPadding:(float)leftPadding rightPadding:(float)rightPadding topPadding:(float)topPadding bottomPadding:(float)bottomPadding
{
    float halfWidth = node.contentSize.width / 2, halfHeight = node.contentSize.height / 2;
    CGSize screen = [CCDirector sharedDirector].winSize;
    
    if (corner == DTLayoutCornerBottomLeft)
        node.position = ccp(leftPadding + halfWidth, bottomPadding + halfHeight);
    else if (corner == DTLayoutCornerTopLeft)
        node.position = ccp(leftPadding + halfWidth, screen.height - topPadding - halfHeight);
    else if (corner == DTLayoutCornerBottomRight)
        node.position = ccp(screen.width - rightPadding - halfWidth,
                            bottomPadding + halfHeight);
    else // Top right...
        node.position = ccp(screen.width - rightPadding - halfWidth / 2,
                            screen.height - topPadding - halfHeight / 2);
}

+(void)layoutNodeFromGooeyConstants:(CCNode *)node toCorner:(DTLayoutCorner)corner
{
    return [HandyFunctions layoutNode:node toCorner:corner leftPadding:GOOEY_PADDING_LEFT rightPadding:GOOEY_PADDING_RIGHT topPadding:GOOEY_PADDING_TOP bottomPadding:GOOEY_PADDING_BOTTOM];
}

@end













