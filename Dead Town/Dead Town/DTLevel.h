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
#import "DTLifeModelDelegate.h"

@class DTCharacter;
@class DTGameLayer;
@class DTPlayer;
@class DTTrigger;

@interface DTLevel : CCNode <DTControllerDelegate, DTButtonDelegate, DTLifeModelDelegate>
{
    @protected
    // Map references
    CCTMXTiledMap *_map;
    CCTMXLayer *_floor, *_walls;
    CCTMXObjectGroup *_spawnObjects, *_triggerObjects;
    NSMutableArray *_triggers;
    // Layout stuff and coordinates
    float _retinaFactor;
    int _tileMapWidth, _tileMapHeight, _tileDimension;
    CGSize _screen;
    // Joystick/Button related variables
    BOOL _joystickActive;
    BOOL _isHoldFiring;
    float _spawnCheckInterval, _spawnCheckTime;
}

@property(nonatomic) DTGameLayer *gameLayer;
@property(nonatomic) DTPlayer *player;
@property(nonatomic, readonly) NSMutableArray *villains;

+(id)levelWithTMXFile:(NSString *)tmxFile;
-(id)initWithTMXFile:(NSString *)tmxFile;

// Coordinate functions
-(void)centerViewportOnPosition:(CGPoint)position;
-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate;
-(BOOL)isWallAtPosition:(CGPoint)position;
-(CGPoint)tileCoordinateForPosition:(CGPoint)point;
-(CGPoint)positionForTileCoordinate:(CGPoint)tileCoordinate; // Returns the centre of the tile
-(CGRect)createRectFromSpawn:(NSDictionary *)spawn;
-(CGPoint)createRectCentreFromSpawn:(NSDictionary *)spawn;
-(CGPoint)centreOfRect:(CGRect)rect;

-(void)addVillain:(DTCharacter *)enemy;

// Handy methods
-(void)addChild:(CCNode *)node;
-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup;

// Some methods you can override when you subclass me
-(void)onPlayerLoaded;
-(void)onVillainKilled:(DTCharacter *) character;
-(void)onTriggerEncountered:(DTTrigger *)trigger;
-(void)onSpawnPointEncountered;

@end








