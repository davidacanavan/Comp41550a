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
#import "DTMelee.h"
#import "DTLevel.h"

@interface PathNode : NSObject

@property(nonatomic) CGPoint tileCoordinate;
@property(nonatomic) float costFromStart, costToEnd;
@property(nonatomic, readonly) float totalCost;
@property(nonatomic, strong) PathNode *parent;

+(id)nodeWithTileCoordinate:(CGPoint)tileCoordinate costFromStart:(float)costFromStart costToEnd:(float)costToEnd parent:(PathNode *)parent;
-(BOOL)isEqual:(id)node;
-(NSString *)description;

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
        self.weapon = [DTMelee weapon];
        _currentPathIndex = -1; // Let's assume we're not on a path at all
        [self notifyMovementStart];
        [self scheduleUpdate];
    }
    
    return self;
}

// Override - Set up the animations in the superclass call
-(CCSprite *)loadSpriteAndAnimations
{
    int frameCount = 7, startNumber = 1;
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"zombie_01.png" capacity:frameCount];
    [self addChild:spriteBatchNode]; // Doesn't render apparently but still needs to be part of the tree
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zombie_01.plist"];
    NSMutableArray *frames = [NSMutableArray array];
    
    for (int i = startNumber; i < startNumber + frameCount; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:[NSString stringWithFormat:@"zombie_01_0%d.png", i]];
        [frames addObject:frame];
    }
    
    _movingAnimation = [CCAnimation animationWithSpriteFrames:frames delay:ANIMATION_RATE]; // TODO: should i cache the animation or what?
    _movingAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_movingAnimation]];
    return [CCSprite spriteWithSpriteFrameName:@"zombie_01_01.png"];
}

-(void)update:(ccTime)delta
{
    if (_currentPathIndex >= 0) // Then we're following a path right now! ... And still have some left
    {
        PathNode *node = [_currentPath objectAtIndex:_currentPathIndex];
        CGPoint targetPosition = [_level positionForTileCoordinate:node.tileCoordinate]; // TODO: Surely i can just store this!
        
        // If we're within one and a half tile distance from the player we don't need to pathfind anymore
        if (ccpFuzzyEqual(self.sprite.position, _player.sprite.position, _level.tileDimension * 1.5))
        {
            _currentPathIndex = -1; // So if we're close enough just make a run for the player!
            [self moveToPosition:[self newPositionTowardsPosition:_player.sprite.position velocity:_velocity delta:delta]];
        }
        else if (ccpFuzzyEqual(targetPosition, self.sprite.position, 2)) // We have arrived at the next tile
            _currentPathIndex--;
        else // Move some more to the next tile
        {
            CGPoint newPosition = [super newPositionTowardsPosition:targetPosition velocity:_velocity delta:delta];
            [self turnToFacePosition:newPosition];
            self.sprite.position = newPosition;
        }
    }
    else if (ccpFuzzyEqual(self.sprite.position, _player.sprite.position, _level.tileDimension * 1.5))
    {
        if (!ccpFuzzyEqual(self.sprite.position, _player.sprite.position, 15))
        {
            CGPoint newPosition = [self newPositionTowardsPosition:_player.sprite.position velocity:_velocity delta:delta];
            
            if (![_level isWallAtPosition:newPosition])
                [self moveToPosition:newPosition];
        }
        
        [self turnToFacePosition:_player.sprite.position];
        [self fire];
    }
    else // Better get a path...
    {
        _currentPath = [self findPathToPlayer];
        _currentPathIndex = _currentPath ? [_currentPath count] - 1 : -1; // -1 if we didn't find a path
    }
}

-(NSMutableArray *)findPathToPlayer
{
    CGPoint zombieTileCoordinate = [_level tileCoordinateForPosition:self.sprite.position];
    CGPoint playerTileCoordinate = [_level tileCoordinateForPosition:_player.sprite.position];
    NSMutableArray *openNodes = [NSMutableArray array];
    NSMutableArray *closedNodes = [NSMutableArray array];
    PathNode *rootNode = [PathNode nodeWithTileCoordinate:zombieTileCoordinate costFromStart:0
            costToEnd:ccpDistance(zombieTileCoordinate, playerTileCoordinate) parent:nil];
    PathNode *targetNode = [PathNode nodeWithTileCoordinate:playerTileCoordinate costFromStart:0
            costToEnd:0 parent:nil]; // For checking
    [openNodes addObject:rootNode]; // So we'll start at the root and go from there
    BOOL pathFound = NO;
    NSMutableArray *finalPath = nil;
    
    do // So keep going until we have the player
    {
        PathNode *lowest = [self findNodeWithMinumumScore:openNodes]; // Get our lowest costing node from the open set
        [closedNodes addObject:lowest]; // Add it to the searched nodes
        [openNodes removeObject:lowest]; // Remove it from the ones left to search
        
        if (CGPointEqualToPoint(lowest.tileCoordinate, playerTileCoordinate)) // We have arrived dear sirs!
        {
            pathFound = YES;
            finalPath = [NSMutableArray array];
            
            while (lowest != nil)
            {
                [finalPath addObject:lowest];
                lowest = lowest.parent;
            }
            
            [finalPath removeLastObject]; // This is the zombie's location so he doesn't need to care, he already knows he's here
            
            break;
        }
        
        [self expandNode:lowest toOpenNodes:openNodes withTargetNode:targetNode andClosedNodes:closedNodes];
    } while ([openNodes count] > 0); // While we still have stuff to search
    
    return finalPath;
}

float ccpManhattanDistance(CGPoint current, CGPoint target)
{
    return fabsf(current.x - target.x) + fabsf(current.y - target.y);
}

-(PathNode *)findNodeWithMinumumScore:(NSMutableArray *)openNodes
{
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
    
    return lowest;
}

-(void)expandNode:(PathNode *)currentNode toOpenNodes:(NSMutableArray *)openNodes withTargetNode:(PathNode *)targetNode andClosedNodes:(NSMutableArray *)closedNodes
{
    int moveCost = 1;
    
    // Look in all 8 directions and if we don't have a wall we can add the node to the open list
    for (int row = -1; row <= 1; row++)
    {
        for (int col = -1; col <= 1; col++)
        {
            CGPoint tileCoordinate = ccpAdd(ccp(row, col), currentNode.tileCoordinate);
            
            if (![_level isWallAtTileCoordinate:tileCoordinate]) // If it's a wall ignore it
            {
                PathNode *node = [PathNode nodeWithTileCoordinate:tileCoordinate costFromStart:currentNode.costFromStart + moveCost costToEnd:ccpManhattanDistance(tileCoordinate, targetNode.tileCoordinate) parent:currentNode];
                
                if ([closedNodes containsObject:node]) // If it's in the closed nodes we just ignore it
                    continue;
                
                int index = [openNodes indexOfObject:node];
                
                if (index == NSNotFound) // Add it to the the open list
                    [openNodes addObject:node];
                else // It's already there so we'll have to update the score
                {
                    PathNode *prior = [openNodes objectAtIndex:index]; // Get the previously calculated node
                    
                    // We have a more efficient way of getting here
                    if (currentNode.costFromStart + moveCost < node.costFromStart)
                        prior.costFromStart = currentNode.costFromStart + moveCost;
                }
            }
        }
    }
}

@end

@implementation PathNode

+(id)nodeWithTileCoordinate:(CGPoint)tileCoordinate costFromStart:(float)costFromStart costToEnd:(float)costToEnd parent:(PathNode *)parent
{
    return [[self alloc] initWithTileCoordinate:tileCoordinate costFromStart:costFromStart costToEnd:costToEnd parent:(PathNode *)parent];
}

-(id)initWithTileCoordinate:(CGPoint)tileCoordinate costFromStart:(float)costFromStart costToEnd:(float)costToEnd parent:(PathNode *)parent
{
    if (self = [super init])
    {
        _tileCoordinate = tileCoordinate;
        _costFromStart = costFromStart;
        _costToEnd = costToEnd;
        _parent = parent;
    }
    
    return self;
}

-(float)totalCost
{
    return _costFromStart + _costToEnd;
}

-(BOOL)isEqual:(id)node
{
    if ([node isKindOfClass:[PathNode class]])
    {
        PathNode *pathNode = (PathNode *) node; // TODO: do i have to cast here?
        return CGPointEqualToPoint(self.tileCoordinate, pathNode.tileCoordinate);
    }
                
    return NO;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%f, %f", self.tileCoordinate.x, self.tileCoordinate.y];
}

@end
















