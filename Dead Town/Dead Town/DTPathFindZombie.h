//
//  DTPathFindZombie.h
//  Dead Town
//
//  Created by David Canavan on 12/04/2013.
//
//

#import "DTCharacter.h"

#define ANIMATION_RATE 0.05f

@class DTPlayer;
@class PathNode;

@interface DTPathFindZombie : DTCharacter
{
    @protected
    DTPlayer *_player;
    NSMutableArray *_currentPath;
    int _currentPathIndex;
    BOOL _isFollowingPath;
}

+(id)zombieWithLevel:(DTLevel *)level position:(CGPoint)position life:(float)life velocity:(float)velocity
              player:(DTPlayer *)player;

@end
