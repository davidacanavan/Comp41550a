//
//  DTGameLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTGameLayer.h"

@implementation DTGameLayer

-(id)init
{
    if ((self = [super init]))
    {
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"DTHospitalF1.tmx"];
        _floor = [_tileMap layerNamed:@"Floor"];
        _walls = [_tileMap layerNamed:@"Walls"];
        _walls.visible = NO; // Make sure no-one can see the transparent tiles!!!
        [self addChild:_tileMap];
    }
    
    return self;
}

@end
