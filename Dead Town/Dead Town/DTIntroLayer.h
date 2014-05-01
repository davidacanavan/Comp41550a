//
//  DTMenuLayer.h
//  Dead Town
//
//  Created by David Canavan on 10/02/2013.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "DTLayer.h"

#define SESSION_ID_STRING @"dead_town_yo"

@class DTOptions;

@interface DTIntroLayer : DTLayer<GKPeerPickerControllerDelegate, GKSessionDelegate>
{
    @private
    // Some of the GUI bits
    CCSprite *_titleSprite;
    CCAnimate *_titleAnimation;
    CCLabelTTF *_nameLabel;
    NSString *_defaultTitleAnimationFrameName;
    CCMenu *_menu;
    
    // The multiplayer stuff
    GKPeerPickerController *_peerPicker;
    GKSession *_session;
    NSString *_peerIdentifier;
    int _playerNumber;
    GKPeerConnectionState _currentPeerConnectionState;
    
    // Options - as always
    DTOptions *_options;
}

@end
