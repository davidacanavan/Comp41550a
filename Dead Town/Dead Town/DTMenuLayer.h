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

#define SESSION_ID_STRING @"dead_town_yo"

@interface DTMenuLayer : CCLayer<GKPeerPickerControllerDelegate, GKSessionDelegate>
{
    @private
    // Some of the GUI bits
    CCSprite *_headingSprite;  
    CCAnimate *_headingAnimation;
    CCSprite *_titleSprite;
    CCMenu *_menu;
    
    // The multiplayer stuff
    GKPeerPickerController *_peerPicker;
    GKSession *_session;
    NSString *_peerIdentifier;
    int _playerNumber;
    GKPeerConnectionState _currentPeerConnectionState;
}

@end
