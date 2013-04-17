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
#import "DTLifeModel.h"

@implementation DTHospitalLevel

+(id)level
{
    return [[self alloc] initWithTMXFile:@"hospitalF1.tmx"];
}

-(id)initWithTMXFile:(NSString *)tmxFile
{
    if (self = [super initWithTMXFile:tmxFile])
    {
        self.shouldCheckForTriggers = YES;
    }
    
    return self;
}

-(void)onTriggerEncountered:(DTTrigger *)trigger
{
    NSDictionary *triggerVariables = [_triggerObjects objectNamed:trigger.name];
    NSDictionary *spawnDict = [_spawnObjects objectNamed:[NSString stringWithFormat:@"ES%@", [triggerVariables objectForKey:@"ES"]]];
    CGPoint spawnPoint = [self createRectCentreFromSpawn:spawnDict];
    
    //DTStraightLineZombie *zombie = [DTStraightLineZombie zombieWithLevel:self position:spawnPoint
    //  life:100 velocity:120 player:_player runningDistance:250];
    
    DTPathFindZombie *zombie = [DTPathFindZombie zombieWithLevel:self position:spawnPoint life:100 velocity:100 player:self.player];
    [self.villains addObject:zombie];
    [zombie.lifeModel addDelegate:self];
    [self addChild:zombie];
}

@end











