//
//  DTLevel.h
//  Dead Town
//
//  Created by David Canavan on 29/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DTLevel : NSObject
{
    CCTMXTiledMap *_map;
    CCTMXLayer *_floor;
    CCTMXLayer *_walls;
}

+(id)levelWithTMXFile:(NSString *)tmxFile;

@end
