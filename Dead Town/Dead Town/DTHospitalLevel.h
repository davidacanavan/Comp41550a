//
//  DTHospitalLevel.h
//  Dead Town
//
//  Created by David Canavan on 16/04/2013.
//
//

#import "DTLevel.h"

#define LEVEL_NAME_HOSPITAL @"hospitalF1.tmx"

@interface DTHospitalLevel : DTLevel
{
    @private
    BOOL _hasPlayedSoundOnLifeChange;
}

+(id)level;
+(id)levelWithSession:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber;

@end
