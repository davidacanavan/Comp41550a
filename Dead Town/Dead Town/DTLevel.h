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
@class DTOptions;
@class DTWeaponPickup;
@class DTHealthPickup;

@interface DTLevel : CCNode <DTControllerDelegate, DTButtonDelegate, DTLifeModelDelegate, GKSessionDelegate>
{
    @protected
    // User settings
    DTOptions *_options;
    
    // Map references
    CCTMXTiledMap *_map;
    CCTMXLayer *_floor, *_walls;
    CCTMXObjectGroup *_spawnObjects, *_triggerObjects, *_pickupObjects;
    NSMutableArray *_triggers, *_pickups;
    
    // Layout stuff and coordinates
    float _retinaFactor;
    int _tileMapWidth, _tileMapHeight;
    CGSize _screen;
    
    // Joystick/Button related variables
    BOOL _joystickActive;
    BOOL _isHoldFiring;
    
    // Object checking
    float _objectCheckInterval, _objectCheckTime;
    
    // Some multiplayer variables - this lets us put them on the update thread so we don't get any jerkyness, experimental!
    BOOL _remotePlayerHasNewPosition;
    CGPoint _remotePlayerNewPosition, _remotePlayerNewVelocity;
}

@property(nonatomic) DTGameLayer *gameLayer;
@property(nonatomic) DTPlayer *player, *remotePlayer;
@property(nonatomic, readonly) NSMutableArray *enemies;
@property(nonatomic, readonly) int tileDimension;
@property(nonatomic) BOOL shouldCheckForObjects;
@property(nonatomic) int enemyDeathCount;

// Multiplayer session variables
@property(nonatomic) GKSession *session;
@property(nonatomic) NSString *peerIdentifier;
@property(nonatomic) int playerNumber;

// State control variables
@property(nonatomic) BOOL isGameOver;

-(id)initWithTMXFile:(NSString *)tmxFile;
-(id)initWithTMXFile:(NSString *)tmxFile session:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber;

// Coordinate functions
-(void)centerViewportOnPosition:(CGPoint)position;
-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate;
-(BOOL)isWallAtPosition:(CGPoint)position;
-(CGPoint)tileCoordinateForPosition:(CGPoint)point;
-(CGPoint)positionForTileCoordinate:(CGPoint)tileCoordinate; // Returns the centre of the tile
-(CGRect)createRectFromTileMapObject:(NSDictionary *)spawn;
-(CGPoint)createRectCentreFromTileMapObject:(NSDictionary *)spawn;
-(CGPoint)centreOfRect:(CGRect)rect;
-(CGPoint)positionOfZombieNumber:(int)number of:(int)total inSpawnRect:(CGRect)rect;

-(void)addEnemy:(DTCharacter *)enemy toLayer:(BOOL)toLayer;
-(NSMutableArray *)closestNumberOf:(int)number enemiesToPlayer:(DTPlayer *)player;

// Multiplayer methods
-(void)sendPlayerMoveToPosition:(CGPoint)position withVelocity:(CGPoint)velocity;
-(void)receivePlayerMove:(DTMessage *)message;

// Handy methods
-(void)addChild:(CCNode *)node;
-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup;
-(void)update:(ccTime)delta;

// Some methods you can override when you subclass me
-(void)onGameLayerReady; // Called when it's ok to add your custom stuff to the GameLayer
-(void)onPlayerLoaded; // Called when the player is loaded
-(void)onPlayerLifeChangedFrom:(float)oldLife to:(float)newLife;
-(BOOL)onPlayerDead; // Return a bool whether we should go to game over or not
-(BOOL)onRemotePlayerDead; // Same as above
-(void)onVillainKilled:(DTCharacter *) character; // Called when we kill a villain
-(BOOL)onTriggerEncountered:(DTTrigger *)trigger; // Called when we encounter a trigger - return yes to remove from layer (yes by default)
-(BOOL)onWeaponPickupEncountered:(DTWeaponPickup *)pickup byPlayer:(DTPlayer *)player; // by default: applies the pickup to the player (plays a sound)
-(BOOL)onHealthPickupEncountered:(DTWeaponPickup *)pickup byPlayer:(DTPlayer *)player; // by default: as above
-(void)onSpawnPointEncountered; // Called when we encounter a spawn point
-(void)onGameOver; // By default goes back to the intro scene and plays the death noise

@end








