//
//  DTLevelSelectLevel.m
//  Dead Town
//
//  Created by David Canavan on 16/04/2013.
//
//

#import "DTLevelSelectLevel.h"
#import "DTPlayer.h"
#import "DTHospitalLevel.h"
#import "DTGameScene.h"
#import "GooeyStatics.h"
#import "DTMenuScene.h"

@implementation DTLevelSelectLevel

+(id)level
{
    return [[self alloc] initWithTMXFile:@"level_select.tmx"];
}

-(id)initWithTMXFile:(NSString *)tmxFile
{
    if (self = [super initWithTMXFile:tmxFile])
    {
        // Find out where the level names should be and add the name sprites
        CCTMXObjectGroup *levelNameLocations = [_map objectGroupNamed:@"Level Names Locations"];
        _levelNameSprites = [NSMutableArray arrayWithCapacity:4];
        [self addTitleSpriteWithImageName:@"level_select_hospital.png" andCentre:[self createRectCentreFromSpawn:[levelNameLocations objectNamed:@"Level Name Hospital"]]];
        [self addTitleSpriteWithImageName:@"level_select_apartments.png" andCentre:[self createRectCentreFromSpawn:[levelNameLocations objectNamed:@"Level Name Apartments"]]];
        [self addTitleSpriteWithImageName:@"level_select_officeblock.png" andCentre:[self createRectCentreFromSpawn:[levelNameLocations objectNamed:@"Level Name Offices"]]];
        [self addTitleSpriteWithImageName:@"level_select_sewer.png" andCentre:[self createRectCentreFromSpawn:[levelNameLocations objectNamed:@"Level Name Sewer"]]];
        
        // Find out where the arrows should be and add them
        CCTMXObjectGroup *arrowSpriteLocations = [_map objectGroupNamed:@"Arrow Sprites Locations"]; // TODO: have arrows here
    }
    
    return self;
}

// Checks for a player intersection with the arrows
-(void)update:(ccTime)delta
{
    [super update:delta];
    DTLevel *level = nil;
    
    for (CCSprite *sprite in _levelNameSprites)
        if (CGRectIntersectsRect(sprite.boundingBox, self.player.sprite.boundingBox))
            level = [DTHospitalLevel level];
    
    if (level) // So if the user selected a level...
    {
        [self unscheduleUpdate];
        CCDirector *director = [CCDirector sharedDirector];
        [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0
            scene: [DTGameScene sceneWithLevel:level] withColor:ccWHITE]];
    }
}

-(void)addTitleSpriteWithImageName:(NSString *)imageName andCentre:(CGPoint)centre
{
    CCSprite *sprite = [CCSprite spriteWithFile:imageName];
    sprite.position = centre;
    [_levelNameSprites addObject:sprite];
    [_map addChild:sprite];
}

// Called when the user presses back to go to the main menu
-(void)backSelected
{
    CCDirector *director = [CCDirector sharedDirector];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [DTMenuScene scene] withColor:ccWHITE]];
}

@end















