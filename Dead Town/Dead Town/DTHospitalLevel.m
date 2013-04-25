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

@implementation DTHospitalLevel

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
        self.shouldCheckForTriggers = YES;
    }
    
    return self;
}

-(BOOL)onTriggerEncountered:(DTTrigger *)trigger
{
    NSDictionary *triggerVariables = [_triggerObjects objectNamed:trigger.name];
    NSDictionary *spawnDict = [_spawnObjects objectNamed:[NSString stringWithFormat:@"ES%@", [triggerVariables objectForKey:@"ES"]]];
    CGPoint spawnPoint = [self createRectCentreFromTileMapObject:spawnDict];
    
    //DTStraightLineZombie *zombie = [DTStraightLineZombie zombieWithLevel:self position:spawnPoint life:100 velocity:120 player:self.player runningDistance:250];
    
    DTPathFindZombie *zombie = [DTPathFindZombie zombieWithLevel:self position:spawnPoint life:100 velocity:100 player:self.player];
    [zombie.lifeModel addDelegate:self];
    [self addEnemy:zombie toLayer:YES];
    return YES;
}

@end











