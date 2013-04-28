//
//  DTLevel.m
//  Dead Town
//
//  Created by David Canavan on 29/03/2013.
//
//

#import "DTLevel.h"
#import "DTCharacter.h"
#import "DTGameLayer.h"
#import "DTHandGun.h"
#import "DTPlayer.h"
#import "DTLifeModelDelegate.h"
#import "DTStatusLayer.h"
#import "DTLifeModel.h"
#import "DTButton.h"
#import "DTTrigger.h"
#import "HandyFunctions.h"
#import "DTPausedScene.h"
#import "SimpleAudioEngine.h"
#import "DTPickup.h"
#import "DTWeaponPickup.h"
#import "DTHealthPickup.h"

@implementation DTLevel

@synthesize gameLayer = _gameLayer;
@synthesize player = _player;
@synthesize session = _session;

#pragma mark-
#pragma mark Initialisation

-(id)initWithTMXFile:(NSString *)tmxFile
{
    return [self initWithTMXFile:tmxFile session:nil peerIdentifier:nil playerNumber:DEFAULT_PLAYER_NUMBER];
}

-(id)initWithTMXFile:(NSString *)tmxFile session:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber
{
    if (self = [super init])
    {
        // Get the user settings and options
        _options = [DTOptions sharedOptions];
        
        // Get all the  map variables
        _map = [CCTMXTiledMap tiledMapWithTMXFile:tmxFile];
        
        _floor = [_map layerNamed:@"Floor"];
        _walls = [_map layerNamed:@"Walls"];
        _spawnObjects = [_map objectGroupNamed:@"Spawns"];
        _triggerObjects = [_map objectGroupNamed:@"Triggers"];
        _pickupObjects = [_map objectGroupNamed:@"Pickups"];
        _walls.visible = NO; // Make sure no-one can see the transparent tiles!!!
        
        // Get some layout dimensions
        _retinaFactor = CC_CONTENT_SCALE_FACTOR();
        _screen = [CCDirector sharedDirector].winSize;
        _tileMapWidth = _map.mapSize.width; // Measured in tiles!
        _tileMapHeight = _map.mapSize.height;
        _tileDimension = _map.tileSize.width / _retinaFactor; // Since they're square I don't need to look at the height - measured in pixels and scaled for retina!
        _objectCheckInterval = .2; // TODO: same for triggers and pickups?
        _objectCheckTime = 0;
        
        // Other things
        _enemyDeathCount = 0;
        
        // Save the multiplayer stuff
        self.session = session;
        self.peerIdentifier = peerIdentifier;
        self.playerNumber = playerNumber;
    }
    
    return self;
}

#pragma mark-
#pragma mark TileMap Functions

-(void)centerViewportOnPosition:(CGPoint) position
{
    CGPoint centerOfView = ccp(_screen.width / 2, _screen.height / 2);
    CGPoint newPosition = ccpSub(centerOfView, position);
    _gameLayer.position = ccp(newPosition.x,  newPosition.y); // Cast to int to prevent artifacts
}

// Converts the layer point to a tile coordinate (they go from top left)
-(CGPoint)tileCoordinateForPosition:(CGPoint)point
{
    // So if the x or y are beyond the screen bounds then fix them to -1 as an off limit coordinate, otherwise we just adjust to normal.
    int x = (point.x < 0) ? -1 : point.x / _tileDimension;
    int mapDimensionInPoints = _tileMapHeight * _tileDimension;
    int y = (point.y > mapDimensionInPoints) ? -1 : (mapDimensionInPoints - point.y) / _tileDimension;
    return ccp(x, y);
}

-(CGPoint)positionForTileCoordinate:(CGPoint)tileCoordinate
{ // Add half to centre the coordinate in the tile
    return ccp(tileCoordinate.x * _tileDimension + _tileDimension / 2,
               _tileDimension * _tileMapHeight - (tileCoordinate.y * _tileDimension) - _tileDimension / 2);
}

-(BOOL)isWallAtPosition:(CGPoint)position
{
    return [self isWallAtTileCoordinate:[self tileCoordinateForPosition:position]];
}

-(BOOL)isWallAtTileCoordinate:(CGPoint)tileCoordinate
{
    // Check the edge of the map and pretend that an out of bounds tile is a wall
    if ([self isTileOutOfBounds:tileCoordinate])
        return YES;
    
    // Here I check the actual tile to see if it's a wall or not
    int gid = [_walls tileGIDAt:tileCoordinate];
    NSDictionary *dict = [_map propertiesForGID:gid];
    return [dict valueForKey:@"IsWall"] != nil;
}

-(BOOL)isTileOutOfBounds:(CGPoint)tileCoordinate
{
    return tileCoordinate.x < 0 || tileCoordinate.y < 0
        || tileCoordinate.x >= _tileMapWidth || tileCoordinate.y >= _tileMapHeight;
}

-(CGRect)createRectFromTileMapObject:(NSDictionary *)spawn
{
    return CGRectMake(
        [[spawn valueForKey:@"x"] floatValue] / _retinaFactor,
        [[spawn valueForKey:@"y"] floatValue] / _retinaFactor,
        [[spawn valueForKey:@"width"] floatValue] / _retinaFactor,
        [[spawn valueForKey:@"height"] floatValue] / _retinaFactor);
}

-(CGPoint)createRectCentreFromTileMapObject:(NSDictionary *)spawn
{
    return [self centreOfRect:[self createRectFromTileMapObject:spawn]];
}

-(CGPoint)centreOfRect:(CGRect)rect
{
    return ccp(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

-(CGPoint)positionOfZombieNumber:(int)number of:(int)total inSpawnRect:(CGRect)rect
{ // For now i space them accross the longest side and centred along the other - this could be expanded in future
    CGSize size = rect.size;
    
    if (size.width > size.height) // We're moving along the x
    {
        float increment = size.width / total;
        return ccp(rect.origin.x + number * increment, rect.origin.y); // TODO: Not centered yet...
    }
    else // Along the y
    {
        float increment = size.height / total;
        return ccp(rect.origin.x, rect.origin.y + number * increment);
    }
}

#pragma mark-
#pragma mark Joystick Delegate

// Called by the controls layer when the joystick is moved
-(void)controllerUpdated:(CGPoint)cvelocity delta:(float)delta
{
    CGPoint oldPosition = [_player getPosition];
    CGPoint velocity = ccpMult(cvelocity, 140);
    CGPoint newPosition = ccp(oldPosition.x + velocity.x * delta,
                              oldPosition.y + velocity.y * delta);
    
    if (_isHoldFiring) // In this case we don't move the player at all, but we still change which way he's facing
    {
        [_player turnToFacePosition:newPosition]; // Tell him where to look
        return;
    }
    
    [_player turnToFacePosition:newPosition]; // Tell him where to look
    
    BOOL isWallAtNewPosition = [self isWallAtPosition:newPosition];
    
    if (isWallAtNewPosition) // Ok so we'll see if he can move in either of the directions seperately
    {
        // Try the x move if possible then the y if we can
        CGPoint xPosition = ccp(oldPosition.x + velocity.x * delta, oldPosition.y);
        CGPoint yPosition = ccp(oldPosition.x, oldPosition.y + velocity.y * delta);
        
        if (![self isWallAtPosition:xPosition]) // So we can move in the x!
        {
            velocity.y = 0; // Make sure they can't move in the y at all
            [self moveThePlayerToPosition:xPosition withVelocity:velocity];
        }
        else if (![self isWallAtPosition:yPosition]) // No x, but the y looks good
        {
            velocity.x = 0;
            [self moveThePlayerToPosition:yPosition withVelocity:velocity];
        }
    }
    else
        [self moveThePlayerToPosition:newPosition withVelocity:velocity];
}

-(void)moveThePlayerToPosition:(CGPoint)position withVelocity:(CGPoint)velocity
{
    [_player moveToPosition:position]; // Update the player position
    [self centerViewportOnPosition:position];
    [self sendPlayerMoveToPosition:position withVelocity:velocity];
}

-(void)controllerMoveStarted
{
    _joystickActive = YES;
    // So he's only moving as long as he's not hold firing! This has to be put in in case the user is hold-firing before he starts to run
    if (!_isHoldFiring)
        [_player notifyMovementStart];
}

-(void)controllerMoveEnded
{
    _joystickActive = NO;
    if (!_isHoldFiring)
        [_player notifyMovementEnd];
}

#pragma mark-
#pragma mark Button Delegate

-(void)buttonPressed:(DTButton *)button // Delegate from the controls layer
{
    if ([button.tag isEqualToString:@"fire"])
    {
        [_player fire];
    }
    else
        [[CCDirector sharedDirector] pushScene:[DTPausedScene scene]];
}

-(void)buttonHoldStarted:(DTButton *)button
{
    _isHoldFiring = YES;
    [_player notifyHoldFireStart];
}

-(void)buttonHoldContinued:(DTButton *)button
{
    [_player notifyMovementEnd]; // So if the user is running we just tell him not to run anymore if a hold fire occurs
}

-(void)buttonHoldEnded:(DTButton *)button
{
    if (_joystickActive)
        [_player notifyMovementStart];
    
    _isHoldFiring = NO;
    [_player notifyHoldFireStop];
}

#pragma mark-
#pragma mark LifeModel Delegate

-(void)lifeChangedFrom:(float)oldLife model:(DTLifeModel *)lifeModel character:(DTCharacter *)character
{
    if (character.characterType == CharacterTypeVillian && [lifeModel isZero])
    {
        [_enemies removeObject: character]; // TODO: This could be faster
        [self onVillainKilled:character];
        [self removeChild:character cleanup:NO];
        _enemyDeathCount++;
    }
    else if (character == _player)
    {
        [self onPlayerLifeChangedFrom:oldLife to:lifeModel.life];
        
        if ([lifeModel isZero])
        {
            BOOL shouldGameOver = [self onPlayerDead];
            
            if (shouldGameOver)
                self.isGameOver = YES;
        }
    }
    else if (character == _remotePlayer) // character won't ever be nil so this is ok
    {
        if ([lifeModel isZero])
        {
            BOOL shouldGameOver = [self onRemotePlayerDead];
            
            if (shouldGameOver)
                self.isGameOver = YES;
        }
    }
}

#pragma mark-
#pragma mark Subclass Overridables

-(void)onGameLayerReady {}
-(void)onPlayerLoaded {}
-(BOOL)onPlayerDead {return YES;} // Returning yes means i just call gameOver by default
-(BOOL)onRemotePlayerDead; {return YES;} // Same as above for the default behaviour
-(void)onVillainKilled:(DTCharacter *)character {}
-(BOOL)onTriggerEncountered:(DTTrigger *)trigger {return YES;} // Remove the trigger by default

-(BOOL)onWeaponPickupEncountered:(DTWeaponPickup *)pickup byPlayer:(DTPlayer *)player
{
    [pickup applyPickupToCharacter:player];
    return YES;
}

-(BOOL)onHealthPickupEncountered:(DTHealthPickup *)pickup byPlayer:(DTPlayer *)player
{
    [pickup applyPickupToCharacter:player];
    return YES;
}

-(void)onSpawnPointEncountered {}

-(void)onGameOver
{
    [_options stopBackgroundTrackIfOptionsAllow];
    [_options playSoundbyteIfOptionsAllow:@"player_death.mp3"]; // http://soundbible.com/1791-Torture.html
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 1.0 scene: [DTIntroScene scene] withColor:ccWHITE]];
}

-(void)onPlayerLifeChangedFrom:(float)oldLife to:(float)newLife {}

#pragma mark-
#pragma mark Property Overrides

-(void)setGameLayer:(DTGameLayer *)gameLayer
{
    // Save the DTGameLayer reference
    _gameLayer = gameLayer;
    [_gameLayer addChild:_map];
    [self createPlayerOrPlayers];
    [self initialiseArrays]; // Get the arrays from the object layers etc...
    
    [self centerViewportOnPosition:[_player getPosition]]; // Center over the player
    [self onPlayerLoaded]; // Notify the subclass
    
    [_gameLayer addChild:self]; // Just so we can get the update
    [self onGameLayerReady]; // Notify the subclass that they can add things in
    [self scheduleUpdate];
}

-(void)initialiseArrays
{
    // Get all the trigger rects and save them
    NSMutableArray *triggerDicts = [_triggerObjects objects];
    _triggers = [NSMutableArray arrayWithCapacity:[triggerDicts count]];
    
    // Save the triggers we have here for later
    for (NSDictionary *dict in triggerDicts)
    {
        [_triggers addObject:[DTTrigger triggerWithName:[dict objectForKey:@"name"]
                                                andRect:[self createRectFromTileMapObject:dict]]];
    }
    
    // Make some space for the enemies
    _enemies = [NSMutableArray arrayWithCapacity:20];
    
    // Make space for the pickups from the object layer
    NSMutableArray *pickupDicts = [_pickupObjects objects];
    _pickups = [NSMutableArray arrayWithCapacity:[pickupDicts count]];
    
    // Save the triggers we have here for later
    for (NSDictionary *dict in pickupDicts)
    {
        if ([[dict objectForKey:@"Class"] isEqualToString:@"DTHealthPickup"]) // It's some health! Hooray!
        {
            float health = [[dict objectForKey:@"Health Change"] floatValue];
            DTHealthPickup *healthPickup = [DTHealthPickup pickupWithHealth:health];
            [self addChild:healthPickup];
            healthPickup.sprite.position = [self createRectCentreFromTileMapObject:dict];
            [_pickups addObject:healthPickup];
        }
        else // It's a weapon
        {
            Class weapon = NSClassFromString([dict objectForKey:@"Class"]); // Get the weapon class
            DTWeaponPickup *weaponPickup = [DTWeaponPickup pickupWithWeapon:[weapon weapon]]; // Create the weapon pickup
            [self addChild:weaponPickup];
            weaponPickup.sprite.position = [self createRectCentreFromTileMapObject:dict];
            [_pickups addObject:weaponPickup];
        }
    }
    
}

-(void)createPlayerOrPlayers
{
    // Create the players
    CGPoint playerOnePosition = [self createRectCentreFromTileMapObject:[_spawnObjects objectNamed:@"Player Spawn 0"]];
    CGPoint playerTwoPosition = ccpAdd(playerOnePosition, ccp(_tileDimension, 5)); // TODO: Put them half-way in the rect instead
    
    if (_playerNumber == PLAYER_ONE) // Then we're player one! Excellent news!
    {
        _player = [DTPlayer playerWithLevel:self position:playerOnePosition life:DEFAULT_PLAYER_LIFE firstLifeModelDelegate:self];
        
        if (_session) // Then we have a player 2 aswell
            _remotePlayer = [DTPlayer playerWithLevel:self position:playerTwoPosition life:DEFAULT_PLAYER_LIFE firstLifeModelDelegate:self];
    }
    else // We're player two! So that means we're definitely playing multiplayer
    {
        _player = [DTPlayer playerWithLevel:self position:playerTwoPosition life:DEFAULT_PLAYER_LIFE firstLifeModelDelegate:self];
        _remotePlayer = [DTPlayer playerWithLevel:self position:playerOnePosition life:DEFAULT_PLAYER_LIFE firstLifeModelDelegate:self];
    }
    
    [_player.lifeModel addDelegate: (id <DTLifeModelDelegate>) _gameLayer.statusLayer.lifeNode]; // TODO: Do I have to cast this?
    [self addChild:_player];
    
    if (_session)
        [self addChild:_remotePlayer];
}

#pragma mark-
#pragma mark Game Updates

-(void)update:(ccTime)delta
{
    if (self.isGameOver)
    {
        [self unscheduleUpdate];
        [self onGameOver];
    }
        
    if (_session) // If we're playing multiplayer jam the updates on the thread here
        [self multiplayerUpdate:delta];
    
    if (_isHoldFiring)
        [_player fire]; // So let him fire
    
    _objectCheckTime += delta;
    
    if (_shouldCheckForObjects && _objectCheckTime >= _objectCheckInterval)
    {
        [self checkForTriggers];
        [self checkForPickups]; // TODO: spawn points etc.. it's ok for the demo not to have them since these are the key ones
        _objectCheckTime = 0;
    }
}

-(void)multiplayerUpdate:(ccTime)delta
{
    if (_remotePlayerHasNewPosition) // So he's moved... Lets move him
    {
        [_remotePlayer turnToFacePosition:_remotePlayerNewPosition];
        _remotePlayer.sprite.position = _remotePlayerNewPosition;
        _remotePlayerHasNewPosition = NO;
    }
}

-(void)checkForTriggers
{
    DTTrigger *triggerToBeRemoved = nil; // TODO: This assumes only one trigger is hit at a time, pretty reasonable me thinks
    
    // I never break the loop since you can intersect multiple ones (TODO: then again the checks would be so quick it could be an optimisation - not a biggie though for now)
    for (DTTrigger *trigger in _triggers)
    {
        if (CGRectIntersectsRect(_player.sprite.boundingBox, trigger.rect))
        {
            BOOL shouldRemove = [self onTriggerEncountered:trigger];
            
            if (shouldRemove)
                triggerToBeRemoved = trigger; // Prevent lots of them coming along
        }
    }
    
    if (triggerToBeRemoved)
        [_triggers removeObject:triggerToBeRemoved];
}

-(void)checkForPickups
{
    id <DTPickup> pickupToBeRemoved = nil;
    
    for (id <DTPickup> pickup in _pickups)
    {
        if (CGRectIntersectsRect(_player.sprite.boundingBox, pickup.sprite.boundingBox))
        {
            BOOL shouldRemove;
            
            if ([pickup isKindOfClass:[DTHealthPickup class]])
                shouldRemove = [self onHealthPickupEncountered:pickup byPlayer:_player];
            else
                shouldRemove = [self onWeaponPickupEncountered:pickup byPlayer:_player];
            
            if (shouldRemove)
                pickupToBeRemoved = pickup; // Prevent lots of them coming along
        }
    }
    
    if (pickupToBeRemoved)
    {
        [self removeChild:pickupToBeRemoved cleanup:NO];
        [_pickups removeObject:pickupToBeRemoved];
    }
}

#pragma mark-
#pragma mark GameLayer Shortcuts

// We wont actually add to this, but since the game thinks this is the game layer it decouples the classes a bit
-(void)addChild:(CCNode *)node
{
    [_gameLayer addChild:node];
}

-(void)removeChild:(CCNode *)node cleanup:(BOOL)cleanup
{
    [_gameLayer removeChild:node cleanup:cleanup];
}

-(void)addEnemy:(DTCharacter *)enemy toLayer:(BOOL)toLayer
{
    [_enemies addObject:enemy];
    
    if (toLayer)
        [self addChild:enemy];
}

// TODO: This only returns 1 for now - don't need multiple yet
-(NSMutableArray *)closestNumberOf:(int)number enemiesToPlayer:(DTPlayer *)player
{
        if ([_enemies count] == 0)
            return nil;
        
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    DTCharacter *closest = [_enemies objectAtIndex:0];
    float currentMin = ccpDistance(player.sprite.position, closest.sprite.position);
    
    for (int i = 1; i < [_enemies count]; i++)
    {
        DTCharacter *next = [_enemies objectAtIndex:i];
        float distance = ccpDistance(player.sprite.position, next.sprite.position);
        
        if (distance < currentMin)
        {
            currentMin = distance;
            closest = next;
        }
    }
    
    [array addObject:closest];
    return array;
}

#pragma mark-
#pragma mark Session, Send & Receive

-(void)setSession:(GKSession *)session
{
    _session = session;
    _session.delegate = self;
    [_session setDataReceiveHandler:self withContext:nil];
}

-(void)invalidateLocalSession
{
    NSLog(@"Invalidate local session");
    if (_session)
    {
        [_session disconnectFromAllPeers];
        _session.available = NO;
        [_session setDataReceiveHandler:nil withContext: nil];
        _session.delegate = nil;
        _session = nil;
    }
}

-(void)sendPlayerMoveToPosition:(CGPoint)position withVelocity:(CGPoint)velocity
{
    if (_session) // So only if we have a valid session...
    {
        // Add messages start with a type code then we add the data
        DTMessagePlayerMoved message;
        message.message.type = MessageTypePlayerMoved;
        message.x = position.x;
        message.y = position.y;
        message.vx = velocity.x;
        message.vy = velocity.y;
        
        // And send that beautiful data!
        [_session sendData:[NSData dataWithBytes:&message length:sizeof(DTMessagePlayerMoved)] toPeers:[NSArray arrayWithObject:self.peerIdentifier] withDataMode:GKSendDataUnreliable error:nil];
    }
}

// Called by the session when we've gotten some data delivered
-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    DTMessage *message = (DTMessage *) [data bytes];
    
    switch (message->type)
    {
        case MessageTypePlayerMoved: // So if we have a move
            [self receivePlayerMove:message];
        break;
            
        default:
            NSLog(@"Unknown data type? Huh?");
        break;
    }
}

// Receive a player move
-(void)receivePlayerMove:(DTMessage *)message
{
    DTMessagePlayerMoved *moveMessage = (DTMessagePlayerMoved *) message;
    _remotePlayerNewPosition = ccp(moveMessage->x, moveMessage->y);
    _remotePlayerHasNewPosition = YES;
}

#pragma mark-
#pragma mark Session Delegate

-(void)session:(GKSession *)session peer:(NSString *)peerIdentifier didChangeState:(GKPeerConnectionState)state
{
    if(state == GKPeerStateDisconnected) // We disconnected dawg
    {
        NSString *message = [NSString stringWithFormat:@"We have been disconnected from %@!", [session displayNameForPeer:peerIdentifier]];
        [HandyFunctions showAlertDialogEntitled:@"Dead Town" withMessage:message];
        [self invalidateLocalSession];
        [[CCDirector sharedDirector] replaceScene:[DTIntroScene scene]];
    }
}

// We don't care about these guys anymore since we've already made the connection
-(void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerIdentifier {}
-(void) session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {}
-(void) session:(GKSession *)session didFailWithError:(NSError *)error {}

-(void)navigateBackToIntroScreenWithTitle:(NSString *)title andMessage:(NSString *)message
{
    [HandyFunctions showAlertDialogEntitled:title withMessage:message];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [DTIntroScene scene] withColor:ccWHITE]];
}

@end



















