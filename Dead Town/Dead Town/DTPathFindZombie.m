//
//  DTPathFindZombie.m
//  Dead Town
//
//  Created by David Canavan on 12/04/2013.
//
//

#import "DTPathFindZombie.h"
#import "DTPlayer.h"
#import "DTConstantDamageCalculator.h"
#import "DTWeapon.h"
#import "DTLevel.h"

@interface PathNode : NSObject

@property(nonatomic) CGPoint tileCoordinate;
@property(nonatomic) float costFromCurrent, costToEnd;
@property(nonatomic, readonly) float totalCost;
@property(nonatomic, strong) PathNode *parent; // TODO: Is weak ok to use here? Better read up on this better!

+(id)nodeWithTileCoordinate:(CGPoint)tileCoordinate costFromCurrent:(float)costFromCurrent costToEnd:(float)costToEnd parent:(PathNode *)parent;

@end

@implementation DTPathFindZombie

+(id)zombieWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life velocity:(float)velocity player:(DTPlayer *)player
{
    return [[self alloc] initWithLevel:level position:position life:life velocity:velocity player:player];
}

-(id)initWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life velocity:(float)velocity player:(DTPlayer *)player
{
    if (self = [super initWithLevel:level position:position life:life characterType:CharacterTypeVillian velocity:velocity])
    {
        _player = player;
        self.weapon = [DTWeapon weaponWithFireRate:2 damageCalculator:[DTConstantDamageCalculator damageWithDamage:5]
                                             range:50];
        _currentPathIndex = 0; // Where we are now in the path array
        [self scheduleUpdate];
    }
    
    return self;
}

-(CCSprite *)loadSpriteAndAnimations
{
    return [CCSprite spriteWithFile:@"zombie_90%-11.png"];
}

-(void)update:(ccTime)delta
{
    if (_currentPath) // Then we're following a path right now!
    {
        PathNode *node = [_currentPath objectAtIndex:_currentPathIndex];
        CGPoint targetPosition = [_level positionForTileCoordinate:node.tileCoordinate]; // TODO: Surely i can just store this!
        
        if (ccpFuzzyEqual(self.sprite.position, _player.sprite.position, 15)) // We're at the player
            _currentPath = nil;
        else if (ccpFuzzyEqual(targetPosition, self.sprite.position, 5)) // We have arrived at the next tile
        {
            _currentPathIndex++;
            
            if (_currentPathIndex == [_currentPath count]) // Then we are at the final tile
                _currentPath = nil;
        }
        else // Move some more to the next tile
        {
            CGPoint newPosition = [super newPositionTowardsPosition:targetPosition velocity:_velocity delta:delta];
            [self turnToFacePosition:newPosition];
            self.sprite.position = newPosition;
        }
    }
    else if (ccpFuzzyEqual(self.sprite.position, _player.sprite.position, 15))
        ; // Then we're attacking! TODO: Put in a section where he acts like a straight line zombie
    else // Better get a path...
    {
        _currentPath = [self findPathToPlayer];
        _currentPathIndex = 0;
    }
}

-(NSMutableArray *)findPathToPlayer
{
    CGPoint zombieTileCoordinate = [_level tileCoordinateForPosition:self.sprite.position];
    CGPoint playerTileCoordinate = [_level tileCoordinateForPosition:_player.sprite.position];
    NSMutableArray *openNodes = [NSMutableArray array];
    NSMutableArray *closedNodes = [NSMutableArray array];
    PathNode *rootNode = [PathNode nodeWithTileCoordinate:zombieTileCoordinate costFromCurrent:0
            costToEnd:ccpDistance(zombieTileCoordinate, playerTileCoordinate) parent:nil];
    PathNode *currentNode = rootNode;
    [closedNodes addObject:currentNode];
    
    while (!CGPointEqualToPoint(currentNode.tileCoordinate, playerTileCoordinate)) // So keep going until we have the player
    {
        // Look in all 8 directions and if we don't have a wall we can add the node to the open list
        for (int row = -1; row <= 1; row++)
            for (int col = -1; col <= 1; col++)
            {
                if (row == 0 && col == 0) // This is the current tile so we don't care
                    continue;
            
                CGPoint tileCoordinate = ccpAdd(ccp(row, col), currentNode.tileCoordinate);
                
                if ([_level isWallAtTileCoordinate:tileCoordinate]) // If it's a wall ignore it
                    continue;
                
                PathNode *node = [PathNode nodeWithTileCoordinate:tileCoordinate costFromCurrent:currentNode.costFromCurrent + 1
                        costToEnd:ccpDistance(tileCoordinate, playerTileCoordinate) parent:currentNode];
                [openNodes addObject:node];
            }
        
        float currentCost = 1000000000; // Start with something unattainably big
        PathNode *lowest = nil; // TODO: use a priority queue, array's are pretty inefficient for this
        
        for (PathNode *node in openNodes) // Get the node with the lowest cost
        {
            if (node.totalCost < currentCost) // TODO: Improve this for a tie - pick the child of the last iteration
            { // TODO: make sure we don't revisit by checking for the parent node when we unfurl the child above
                currentCost = node.totalCost;
                lowest = node;
            }
        }
        
        [openNodes removeObject:lowest]; // Make sure we don't go back here
        currentNode = lowest;
    }
    
    // Now lets remake the node chain so that the root is the first... TODO: This can be done waaaya better dave
    NSMutableArray *stack = [NSMutableArray array];
    
    while (currentNode.parent != nil)
    {
        [stack addObject:currentNode];
        currentNode = currentNode.parent;
    }
    
    return stack;
}

@end

@implementation PathNode

+(id)nodeWithTileCoordinate:(CGPoint)tileCoordinate costFromCurrent:(float)costFromCurrent costToEnd:(float)costToEnd parent:(PathNode *)parent
{
    return [[self alloc] initWithTileCoordinate:tileCoordinate costFromCurrent:costFromCurrent costToEnd:costToEnd parent:(PathNode *)parent];
}

-(id)initWithTileCoordinate:(CGPoint)tileCoordinate costFromCurrent:(float)costFromCurrent costToEnd:(float)costToEnd parent:(PathNode *)parent
{
    if (self = [super init])
    {
        _tileCoordinate = tileCoordinate;
        _costFromCurrent = costFromCurrent;
        _costToEnd = costToEnd;
        _totalCost = costFromCurrent + costToEnd;
        _parent = parent;
    }
    
    return self;
}

@end
















