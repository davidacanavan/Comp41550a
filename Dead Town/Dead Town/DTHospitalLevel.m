//
//  DTHospitalLevel.m
//  Dead Town
//
//  Created by David Canavan on 16/04/2013.
//
//

#import "DTHospitalLevel.h"
#import "DTTrigger.h"
#import "DTPathFindZombie.h"
#import "DTStraightLineZombie.h"
#import "DTLifeModel.h"
#import "DTOptions.h"
#import "HandyFunctions.h"
#import "CCDirector.h"

@implementation DTHospitalLevel

#pragma mark-
#pragma mark Initialisers

+(id)level
{
    return [[self alloc] initWithTMXFile:LEVEL_NAME_HOSPITAL session:nil peerIdentifier:nil playerNumber:DEFAULT_PLAYER_NUMBER];
}

+(id)levelWithSession:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber
{
    return [[self alloc] initWithTMXFile:LEVEL_NAME_HOSPITAL session:session peerIdentifier:peerIdentifier playerNumber:playerNumber];
}

-(id)initWithTMXFile:(NSString *)tmxFile session:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber
{
    if (self = [super initWithTMXFile:tmxFile session:session peerIdentifier:peerIdentifier playerNumber:playerNumber])
    {
        self.shouldCheckForObjects = YES;
    }
    
    return self;
}

#pragma mark-
#pragma mark Superclass Event Overrides

-(BOOL)onTriggerEncountered:(DTTrigger *)trigger
{
    if ([trigger.name isEqualToString:@"End Game"])
    {
        [self navigateBackToIntroScreenWithTitle:@"Fantastic!" andMessage:@"You didn't die... Yet!"];
    }
    
    NSDictionary *triggerVariables = [_triggerObjects objectNamed:trigger.name];
    NSArray *spawnPointsToActivate = [[triggerVariables objectForKey:@"ES"] componentsSeparatedByString:@" "];
    
    for (NSString *spawnCode in spawnPointsToActivate)
    {
        NSDictionary *spawnDict = [_spawnObjects objectNamed:[NSString stringWithFormat:@"ES%@", spawnCode]];
        CGRect spawnRect = [self createRectFromTileMapObject:spawnDict];
        CGPoint spawnPoint = [self createRectCentreFromTileMapObject:spawnDict];
        
        // Get how much of each zombie we'll have to make
        int straightLineZombieCount = [[spawnDict objectForKey:@"DTStraightLineZombie"] intValue];
        int pathFindZombieCount = [[spawnDict objectForKey:@"DTPathFindZombie"] intValue];
        
        for (int i = 0; i < straightLineZombieCount; i++)
        {
            int velocity = (int) [HandyFunctions uniformFrom:60 to:150];
            CGPoint position = [self positionOfZombieNumber:i of:straightLineZombieCount inSpawnRect:spawnRect];
            DTStraightLineZombie *zombie = [DTStraightLineZombie zombieWithLevel:self position:position life:100 velocity:velocity player:self.player runningDistance:400];
            [zombie.lifeModel addDelegate:self];
            [self addEnemy:zombie toLayer:YES];
        }
        
        for (int i = 0; i < pathFindZombieCount; i++)
        {
            int velocity = (int) [HandyFunctions uniformFrom:90 to:120];
            DTPathFindZombie *zombie = [DTPathFindZombie zombieWithLevel:self position:spawnPoint life:100 velocity:velocity player:self.player];
            [zombie.lifeModel addDelegate:self];
            [self addEnemy:zombie toLayer:YES];
        }
    }
    
    return YES;
}

-(void)onPlayerLoaded
{
    [super onPlayerLoaded];
    [_options playSoundbyteIfOptionsAllow:@"player_lock_and_load.mp3"];
}

-(void)onVillainKilled:(DTCharacter *)character
{
    [super onVillainKilled:character];
    
    if (self.enemyDeathCount % 10 == 0) // Every 10 kills...
        [_options playSoundbyteIfOptionsAllow:@"player_burn_punk.mp3"];
}

-(void)onPlayerLifeChangedFrom:(float)oldLife to:(float)newLife
{
    if (!_hasPlayedSoundOnLifeChange && newLife < 50) // So we'll only play this once!
    {
        [_options playSoundbyteIfOptionsAllow:@"player_all_you_got.mp3"];
        _hasPlayedSoundOnLifeChange = true;
    }
}

-(BOOL)onWeaponPickupEncountered:(DTWeaponPickup *)pickup byPlayer:(DTPlayer *)player
{
    [_options playSoundbyteIfOptionsAllow:@"player_hell_yeah.mp3"];
    return [super onWeaponPickupEncountered:pickup byPlayer:player];
}

-(BOOL)onHealthPickupEncountered:(DTWeaponPickup *)pickup byPlayer:(DTPlayer *)player
{
    [_options playSoundbyteIfOptionsAllow:@"player_good_squishy.mp3"];
    return [super onHealthPickupEncountered:pickup byPlayer:player];
}

@end











