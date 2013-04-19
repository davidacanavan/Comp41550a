//
//  DTLevelSelectLevel.h
//  Dead Town
//
//  Created by David Canavan on 16/04/2013.
//
//

#import "DTLevel.h"

#define LEVEL_NAME_LEVEL_SELECT @"level_select.tmx"

@interface DTLevelSelectLevel : DTLevel
{
    @private // I don't intend anyone to subclass this
    NSMutableArray *_levelNameSprites;
}

+(id)level;
+(id)levelWithSession:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber;

@end
