//
//  DTLevel.h
//  Dead Town
//
//  Created by David Canavan on 29/03/2013.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "DTControllerDelegate.h"
#import "DTButtonDelegate.h"
#import "DTLifeModelDelegate.h"
#import "DTMultiplayerTypes.h"

#define DEFAULT_PLAYER_NUMBER 1
#define PLAYER_ONE 1
#define PLAYER_TWO 2
#define DEFAULT_PLAYER_LIFE 100

@class DTCharacter;
@class DTGameLayer;
@class DTPlayer;
@class DTTrigger;

@interface DTLevel : CCNode <DTControllerDelegate, DTButtonDelegate, DTLifeModelDelegate, GKSessionDelegate>
{
    @protected
    // Map references
    CCTMXTiledMap *_map;
    CCTMXLayer *_floor, *_walls;
    CCTMXObjectGroup *_spawnObjects, *_triggerObjects;
    NSMutableArray *_triggers;
    // Layout stuff and coordinates
    float _retinaFactor;
    int _tileMapWidth, _tileMapHeight;
    CGSize _screen;
    // Joystick/Button related variables
    BOOL _joystickActive;
    BOOL _isHoldFiring;
    float _spawnCheckInterval, _spawnCheckTime;
    
    // Some multiplayer variables - this lets us put them on the update thread so we don't get any jerkyness
    BOOL _remotePlayerHasNewPosition;
    CGPoint _remotePlayerNewPosition;
}

@property(nonatomic) DTGameLayer *gameLayer;
@property(nonatomic) DTPlayer *player, *remotePlayer;
@property(nonatomic, readonly) NSMutableArray *villains;
@property(nonatomic, readonly) int tileDimension;
@property(nonatomic) BOOL shouldCheckForTriggers;

// Multiplayer session variables
@property(nonatomic) GKSession *session;
@property(nonatomic) NSString *peerIdentifier;
@property(nonatomic) int playerNumber;

-(id)initWithTMXFile:(NSString *)tmxFile;
-(id)initWithTMXFile:(NSString *)tmxFile session:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber;

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

// Multiplayer methods
-(void)sendPlayerMoveToPosition:(CGPoint)position withVelocity:(CGPoint)velocity;
-(void)receivePlayerMove:(DTMessage *)message;

// Handy methods
-(void)addChild:(CCNode *)node;
-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup;
-(void)update:(ccTime)delta;

// Some methods you can override when you subclass me
-(void)onGameLayerReady; // Called when it's ok to add your custom stuff to the GameLayer
-(void)onPlayerLoaded;
-(void)onVillainKilled:(DTCharacter *) character;
-(void)onTriggerEncountered:(DTTrigger *)trigger;
-(void)onSpawnPointEncountered;

@end








