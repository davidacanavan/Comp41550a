//
//  DTStraightLineZombie.h
//  Dead Town
//
//  Created by David Canavan on 19/02/2013.
//
//

#import "DTCharacter.h"
#import "DTGameLayer.h"

@class DTPlayer;

// A zombie that runs after you in a straight line when the player comes a certain distance from him
@interface DTStraightLineZombie : DTCharacter
{
    @protected
    DTPlayer *_player;
    float _runningDistance;
}

+(id)zombieWithPlayer:(DTPlayer *)player runningDistance:(float)runningDistance gameLayer:(DTGameLayer *)gameLayer position:(CGPoint)position life:(float)life maxAttacksPerSecond:(int)maxAttacksPerSecond;

@end
