//
//  DTHospitalLevel.h
//  Dead Town
//
//  Created by David Canavan on 16/04/2013.
//
//

#import "DTLevel.h"

#define LEVEL_NAME_HOSPITAL_SHOWCASE @"hospital_showcase.tmx"

@interface DTShowcaseLevel : DTLevel
{
    @private
    BOOL _hasPlayedSoundOnLifeChange;
}

+(id)level;
+(id)levelWithSession:(GKSession *)session peerIdentifier:(NSString *)peerIdentifier playerNumber:(int)playerNumber;

@end
