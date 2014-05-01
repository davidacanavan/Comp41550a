//
//  DTSpeechBoxNode.h
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define TEXT_SPEED 60
#define TEXT_FONT_FILE @"text_font.fnt"

@interface DTSpeechBoxNode : CCLayerColor
{
    @private
	CCLabelBMFont *_textLabel;
    
	NSString *_text;
	NSMutableArray *_lines;
    
	float _progress;
	int _linesPerPage;
	int _currentPageIndex;
	NSMutableString *_currentPage;
	int _currentPageCharCount;
    
	int _totalPages;
	BOOL _ended;
}

+(id)nodeWithColor:(ccColor4B)colour bounds:(CGSize)size padding:(float)padding text:(NSString *)text;

@end













