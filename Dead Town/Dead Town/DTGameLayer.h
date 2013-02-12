//
//  DTGameLayer.h
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "cocos2d.h"

@interface DTGameLayer : CCLayer
{
    CCTMXTiledMap *_tileMap;
    int _tileMapWidth;
    int *_tileMapHeight;
    int *_tileDimension;
    CCTMXLayer *_floor;
    CCTMXLayer *_walls;
}

@end
