//
//  DTLevelSelectLevel.h
//  Dead Town
//
//  Created by David Canavan on 16/04/2013.
//
//

#import "DTLevel.h"

@interface DTLevelSelectLevel : DTLevel
{
    @private // I don't intend anyone to subclass this
    NSMutableArray *_levelNameSprites;
}

+(id)level;

@end
