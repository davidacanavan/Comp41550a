//
//  DTLevel.h
//  Dead Town
//
//  Created by David Canavan on 29/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DTControllerDelegate.h"
#import "DTButtonDelegate.h"

@class DTCharacter;
@class DTGameLayer;

@interface DTLevel : NSObject <DTControllerDelegate, DTButtonDelegate>
{
    @protected
    // Map references
    CCTMXTiledMap *_map;
    CCTMXLayer *_floor;
    CCTMXLayer *_walls;
    CCTMXObjectGroup *_spawns;
    // Layout stuff and coordinates
    float _retinaFactor;
    int _tileMapWidth, _tileMapHeight, _tileDimension;
    CGSize _screen;
    // Joystick/Button related variables
    BOOL _joystickActive;
    BOOL _isHoldFiring;
    // Other stuff i'll need
    DTGameLayer *_gameLayer;
    DTCharacter *_player;
}

+(id)levelWithTMXFile:(NSString *)tmxFile gameLayer:(DTGameLayer *)gameLayer;
-(id)initWithTMXFile:(NSString *)tmxFile gameLayer:(DTGameLayer *)gameLayer;

-(NSMutableArray *)closestEnemiesToPlayer;

// Coordinate functions
-(void)centerViewportOnPosition:(CGPoint)position;
-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate;
-(BOOL)isWallAtPosition:(CGPoint)position;
-(CGPoint)tileCoordinateForPosition:(CGPoint)point;

// Some methods you can override when you subclass me
-(void)onPlayerLoaded;
-(void)onTriggerTileEncountered;
-(void)onSpawnPointEncountered;

@end








