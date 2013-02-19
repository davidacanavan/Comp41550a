//
//  DTStraightLineZombie.h
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "cocos2d.h"
#import "DTCharacter.h"
#import "DTPlayer.h"

// A zombie that runs after you in a straight line when the player comes a certain distance from him
@interface DTStraightLineZombie : DTCharacter
{
    @protected
    DTPlayer *_player;
    float _runningDistance;
}

+(id)zombieWithPlayer:(DTPlayer *)player andRunningDistance:(float)runningDistance withGameLayer:(DTGameLayer *)gameLayer andPosition:(CGPoint)position;

@end
