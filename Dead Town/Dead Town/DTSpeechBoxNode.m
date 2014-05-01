//
//  DTSpeechBoxNode.m
//  Dead Town
//
//  Created by David Canavan on 01/05/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "DTSpeechBoxNode.h"


@implementation DTSpeechBoxNode

+(id)nodeWithColor:(ccColor4B)colour bounds:(CGSize)bounds padding:(float)padding text:(NSString *)text
{
    return [[self alloc] initWithColor:colour bounds:bounds padding:padding text:text];
}

-(id)initWithColor:(ccColor4B)colour bounds:(CGSize)bounds padding:(float)padding text:(NSString *)text
{
    if (self = [super initWithColor:colour width:bounds.width + 2 * padding height:bounds.height + 2 * padding])
    {
        self.isTouchEnabled = YES;
        
		_ended = NO;
		_currentPageIndex = 0;
		CCBMFontConfiguration *conf = FNTConfigLoadFile(TEXT_FONT_FILE);
		_linesPerPage = bounds.height / conf->commonHeight_ * [CCDirector sharedDirector].contentScaleFactor;
		NSArray *words = [text componentsSeparatedByString:@" "];
		NSMutableString *wrappedText = [NSMutableString string];
		_lines = [[NSMutableArray alloc] init];
        int wc = 0;
        
		for (NSString *word in words)
        {
            NSString *eval = nil;
            
            if (wc == 0)
                eval = word;
            else
                eval = [wrappedText stringByAppendingFormat:@" %@", word];
            
			int size = [self calculateStringSize:eval];
            
			// See if the text so far plus the new word fits the rect
			if (size > bounds.width)
            {
				// If not, closes this line and starts a new one
				[_lines addObject:[NSString stringWithString:wrappedText]];
				[wrappedText setString:word];
			}
            else
            {
                if (wc > 0)
                {
                    [wrappedText appendString:@" "];
                }
                
				[wrappedText appendString:word];
			}
            
            wc++;
		}
        
		[_lines addObject:[NSString stringWithString:wrappedText]];
        
		_totalPages = ceil((float) [_lines count] / _linesPerPage);
		_text = text;
		_textLabel = [CCLabelBMFont labelWithString:[self nextPage] fntFile:TEXT_FONT_FILE];
		_textLabel.anchorPoint = ccp(0,1);
		_textLabel.position = ccp(padding, bounds.height + padding);
        
		// Hides all characters in the label
		for (CCNode *node in _textLabel.children)
        {
			CCSprite *charSpr = (CCSprite *)node;
			charSpr.opacity = 0;
		}
        
		[self addChild:_textLabel];
    }
    
    return self;
}

- (void)update:(ccTime)delta
{
	_progress += (delta * TEXT_SPEED);
    
	int visible = _progress;
    
	if (visible > _currentPageCharCount)
    {
		_progress = visible = _currentPageCharCount;
	}
    
	// Each character sprite is assigned a tag corresponding to its index in the string,
	// and even though line-breaks are skipped, they are still counted for tag purposes.
	// Therefore, we use an offset so that the tag is correct.
	int offset = 0;
    
	for (int i = 0; i < visible; i++)
    {
        
		if ([_currentPage characterAtIndex:i + offset] == '\n') {
			offset++;
		}
        
		CCSprite *charSpr = (CCSprite *) [_textLabel getChildByTag:i + offset];
		charSpr.opacity = 255;
	}
}

- (NSString *)nextPage
{
	_progress = 0;
	_currentPage = [NSMutableString string];
	_currentPageCharCount = 0;
	int line = _currentPageIndex * _linesPerPage;
	int i = 0;
    
	while (i < _linesPerPage && line < [_lines count])
    {
		[_currentPage appendFormat:@"%@\n", [_lines objectAtIndex:line]];
		_currentPageCharCount += [[_lines objectAtIndex:line] length];
		i++;
		line++;
	}
    
	_currentPageIndex++;
	return _currentPage;
}

typedef struct _FontDefHashElement
{
    NSUInteger		key;		// key. Font Unicode value
    ccBMFontDef		fontDef;	// font definition
    UT_hash_handle	hh;
} tFontDefHashElement;

- (int)calculateStringSize:(NSString *)text
{
    
	CCBMFontConfiguration *conf = FNTConfigLoadFile(TEXT_FONT_FILE);
    
	int totalSize = 0;
    
	for (int i = 0; i < [text length] / [CCDirector sharedDirector].contentScaleFactor; i++)
    {
        int c = [text characterAtIndex:i];
        tFontDefHashElement *def = NULL;
        HASH_FIND_INT(conf->fontDefDictionary_, &c, def);
		totalSize += def->fontDef.xAdvance;
	}
    
	return totalSize;
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_progress < _currentPageCharCount)
    {
		for (CCNode *node in _textLabel.children)
        {
			CCSprite *charSpr = (CCSprite *)node;
			charSpr.opacity = 255;
		}
        
		_progress = _currentPageCharCount;
	}
    else
    {
		if (_currentPageIndex < _totalPages)
        {
			[_textLabel setString:[self nextPage]];
            
			for (CCNode *node in _textLabel.children)
            {
				CCSprite *charSpr = (CCSprite *)node;
				charSpr.opacity = 0;
			}
            
			//if ([delegate respondsToSelector:@selector(textBox:didMoveToPage:)])
            //{
		//		[delegate textBox:(id<TextBox>) self didMoveToPage:currentPageIndex];
		//	}
            
		}
        else
        {
            
			if (!_ended)
            {
				_ended = YES;
                
				//if ([delegate respondsToSelector:@selector(textBox:didFinishAllTextWithPageCount:)])
                //{
				//	[delegate textBox:(id<TextBox>) self didFinishAllTextWithPageCount:totalPages];
				//}
			}
		}
	}
}

@end












