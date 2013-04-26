//
//  DTMenuLayer.m
//  Dead Town
//
//  Created by David Canavan on 10/02/2013.
//
//

#import "DTIntroLayer.h"
#import "DTGameScene.h"
#import "HandyFunctions.h"
#import "DTLevelSelectLevel.h"
#import "DTOptionsScene.h"
#import "DTOptions.h"

@implementation DTIntroLayer

-(id)init
{
    if ((self = [super init]))
    {
        CGSize screen = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"intro_background.png"];
        backgroundSprite.position = ccp(screen.width / 2, screen.height / 2);
        [self addChild: backgroundSprite z:-1];
        
        _titleSprite = [self loadTitleAnimation];
        _titleSprite.position = ccp(screen.width / 2, screen.height + _titleSprite.boundingBox.size.height / 2);
        [self addChild: _titleSprite z:1];
        
        CCMenuItemImage *onePlayerMenuItem = [HandyFunctions menuItemWithImageName:@"intro_one_player.png" target:self selector:@selector(onePlayerModeSelected)];
        CCMenuItemImage *twoPlayerMenuItem = [HandyFunctions menuItemWithImageName:@"intro_two_player.png" target:self selector:@selector(twoPlayerModeSelected)];
        
        _menu = [CCMenu menuWithItems:onePlayerMenuItem, twoPlayerMenuItem, nil];
        [_menu alignItemsHorizontallyWithPadding:40];
        _menu.position = ccp(screen.width / 2, -_menu.boundingBox.size.height / 2);
        [self addChild:_menu z:2];
        
        _options = [DTOptions sharedOptions];
    }
    
    return self;
}

#pragma mark-
#pragma mark Animation Methods

-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    CGSize screen = [CCDirector sharedDirector].winSize;
    [_titleSprite runAction: [CCSequence actions:
                [CCMoveTo actionWithDuration:0.4 position:ccp(screen.width / 2, screen.height * 0.67)],
                [CCCallFunc actionWithTarget:self selector:@selector(animateMenuIn)],
                nil]];
    [_options playBackgroundTrackIfOptionsAllow:@"backing_track.mp3" onLoop:YES];
}

-(void)animateMenuIn
{
    CGSize screen = [CCDirector sharedDirector].winSize;
    [_menu runAction:[CCSequence actions:
                      [CCMoveTo actionWithDuration:0.2 position:ccp(screen.width / 2, screen.height * .35)],
                      [CCCallFunc actionWithTarget:self selector:@selector(animateTitle)],
                      nil]];
}
     
-(void)animateTitle
{
    float uniform = [HandyFunctions uniformFrom:2 to:12];
    CCDelayTime *delayBetweenAnimations = [CCDelayTime actionWithDuration:uniform];
    [_titleSprite runAction:[CCSequence actions:delayBetweenAnimations, _titleAnimation,
            [CCCallFunc actionWithTarget:self selector:@selector(animateTitle)], nil]];
    _titleSprite.displayFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_defaultTitleAnimationFrameName];
}

-(void)animateTitleShake // TODO: maybe
{
    
}

// Override - Set up the animations in the superclass call
-(CCSprite *)loadTitleAnimation
{
    // Set up the animation frames
    CCSpriteBatchNode *spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"intro_title.png" capacity:10];
    [self addChild:spriteBatchNode]; // Doesn't render apparently but still needs to be part of the tree
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"intro_title.plist"];
    NSMutableArray *frames = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"intro_title_%d.png", i]];
        [frames addObject:frame];
    }
    
    _defaultTitleAnimationFrameName = @"intro_title_0.png";
    _titleAnimation = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.06f]];
    return [CCSprite spriteWithSpriteFrameName:_defaultTitleAnimationFrameName];
}

#pragma mark-
#pragma mark Button Selectors

// The one player mode has been selected - now we just have to replace the scene with the level select scene
-(void)onePlayerModeSelected
{
    CCDirector *director = [CCDirector sharedDirector];
    DTGameScene *scene = [DTGameScene sceneWithLevel:[DTLevelSelectLevel level]];
    [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene:scene withColor:ccWHITE]];
}

// In this case we scan for another device using gamekit
-(void)twoPlayerModeSelected
{
    [self searchForPeer]; // Try find a player
}

#pragma mark-
#pragma mark Handy Connection Methods

-(void)searchForPeer
{
    NSLog(@"Search for peer");
    // Create the picker view controller and set us as the delegate
    _peerPicker = [[GKPeerPickerController alloc] init]; 
    _peerPicker.delegate = self;
    
    // Only go for local connections since I don't wanna have to construct my own picker
    _peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    
    // Show the picker and we'll be the number one player since we're searching
    [_peerPicker show];
    _playerNumber = 1;
}

-(void)invalidateLocalSession
{
    NSLog(@"Invalidate local session");
    if (_session)
    {
        [_session disconnectFromAllPeers];
        _session.available = NO;
        [_session setDataReceiveHandler:nil withContext: nil];
        _session.delegate = nil;
        _session = nil;
    }
}

#pragma mark-
#pragma mark Peer Picker Delegates

// We have to create our own session here and return it when the peer picker asks for it
-(GKSession*)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    NSLog(@"Create the session");
    // Allocate the session and save it to an instance variable, set the delegate
    _session = [[GKSession alloc] initWithSessionID:SESSION_ID_STRING displayName:nil sessionMode:GKSessionModePeer];
    _session.delegate = self;
    return _session;
}

// The controller has connected a peer to a session
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString*)peerIdentifier toSession:(GKSession *)currSession
{
    NSLog(@"Connected peer to session");
    // Dismiss the peerPicker
    [_session setDataReceiveHandler:self withContext:nil];
    [_peerPicker dismiss];
    _peerPicker.delegate = nil;
    //Set the other player's ID
    _peerIdentifier = peerIdentifier;
}

// The user cancelled the connection attempt
-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    NSLog(@"Peer did cancel");
    picker.delegate = nil;
    [self invalidateLocalSession];
}

#pragma mark-
#pragma mark Session Delegates

-(void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerIdentifier
{
    _playerNumber = 2;
}

-(void) session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    // Connection Failed
    [_peerPicker dismiss];
    _peerPicker.delegate = nil;
    [self invalidateLocalSession];
}

-(void) session:(GKSession *)session didFailWithError:(NSError *)error
{
    // Connection Failed
    [_peerPicker dismiss];
    _peerPicker.delegate = nil;
    [self invalidateLocalSession];
}

-(void)session:(GKSession *)session peer:(NSString *)peerIdentifier didChangeState:(GKPeerConnectionState)state
{
    if (_currentPeerConnectionState == GKPeerStateConnecting && state != GKPeerStateConnected)
        _playerNumber = 1; // Reset the player number
    else if (state == GKPeerStateConnected)
    {
        // Now we're connected to a peer!!! Wooo baby wooo!
        CCDirector *director = [CCDirector sharedDirector];
        DTLevel *level = [DTLevelSelectLevel levelWithSession:session peerIdentifier:peerIdentifier playerNumber:_playerNumber];
        DTGameScene *scene = [DTGameScene sceneWithLevel:level];
        [director replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene:scene withColor:ccWHITE]];
    }
    else if(state == GKPeerStateDisconnected)
    {
        // We were disconnected
        // [self unscheduleUpdate];
        // User alert
        NSString *message = [NSString stringWithFormat:@"We have been disconnected from %@!", [session displayNameForPeer:peerIdentifier]];
        [HandyFunctions showAlertDialogEntitled:@"Dead Town" withMessage:message];
        [self invalidateLocalSession];
    }
    
    // Keep the current state
    _currentPeerConnectionState = state;
}

@end


















