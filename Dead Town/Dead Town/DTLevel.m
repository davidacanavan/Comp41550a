//
//  DTLevel.m
//  Dead Town
//
//  Created by David Canavan on 29/03/2013.
//
//

#import "DTLevel.h"

@implementation DTLevel

+(id)levelWithTMXFile:(NSString *)tmxFile
{
    return [[self alloc] initWithTMXFile:tmxFile];
}

-(id)initWithTMXFile:(NSString *)tmxFile
{
    if (self = [super init])
    {
        _map = [CCTMXTiledMap tiledMapWithTMXFile:tmxFile];
        _floor = [_map layerNamed:@"Floor"];
        _walls = [_map layerNamed:@"Walls"];
    }
    
    return self;
}

@end
