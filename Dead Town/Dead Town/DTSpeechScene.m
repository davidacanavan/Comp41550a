//
//  DTSpeechScene.m
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DTSpeechScene.h"
#import "TextBoxLayer.h"
#import "DTLayer.h"

@implementation DTSpeechScene

+(id)sceneWithText:(NSString *)text
{
    return [[self alloc] initWithText:text backgroundSprite:nil darkeningFactor:0];
}

+(id)sceneWithText:(NSString *)text backgroundSprite:(CCSprite *)backgroundSprite darkeningFactor:(float)darkeningFactor
{
    return [[self alloc] initWithText:text backgroundSprite:backgroundSprite darkeningFactor:darkeningFactor];
}

-(id)initWithText:(NSString *)text backgroundSprite:(CCSprite *)backgroundSprite darkeningFactor:(float)darkeningFactor
{
    if (self = [super init])
    {
        // Add the background behind everything else
        if (backgroundSprite)
            [self addChild:[DTLayer layerWithBackgroundSprite:backgroundSprite darkeningFactor:darkeningFactor]];
        
        // Create the text and set it
        CGSize screen = [[CCDirector sharedDirector] winSize];
        float width = screen.width - 80, height = screen.height - 80;
        UIColor *color = [UIColor clearColor];
        _textBoxLayer = [[TextBoxLayer alloc] initWithColor:color width:width height:height padding:0 speed:0.02f text:text];
        _textBoxLayer.delegate = self;
        _textBoxLayer.position = ccp((screen.width - width) / 2, (screen.height - height) / 2);
    }
    
    return self;
}

- (void)onEnterTransitionDidFinish
{
    [self addChild:_textBoxLayer];
    [_textBoxLayer scheduleUpdate];
}

-(void)textBox:(id<TextBox>)textBox didFinishAllTextWithPageCount:(int)pageCount
{
    [[CCDirector sharedDirector] popScene];
}

@end










