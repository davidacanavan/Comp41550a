//
//  DTGameLayer.m
//  Dead Town
//
//  Created by David Canavan on 12/02/2013.
//
//

#import "DTGameLayer.h"
#import "SimpleAudioEngine.h"
#import "DTLifeModel.h"
#import "DTStatusLayer.h"
#import "DTControlsLayer.h"

@implementation DTGameLayer

@synthesize isPausing = _isPausing;
@synthesize controlsLayer = _controlsLayer;

#pragma mark-
#pragma mark Initialisation

+(id)gameLayerWithStatusLayer:(DTStatusLayer *)statusLayer
{
    return [[self alloc] initWithStatusLayer:statusLayer];
}

-(id)initWithStatusLayer:(DTStatusLayer *)statusLayer
{
    if ((self = [super init]))
    {
        _statusLayer = statusLayer;
        _isGameOver = NO;
        _options = [DTOptions sharedOptions];
        
        [self scheduleUpdate];
    }
    
    return self;
}

#pragma mark-
#pragma mark Entry/Exit

-(void)onEnter // Gotta see if the defaults have been changed
{
    [super onEnter];
    
    if (_options.controllerType != self.controlsLayer.controllerType)
        self.controlsLayer.controllerType = _options.controllerType;
    
    if (_options.dominantHand != self.controlsLayer.dominantHand)
        self.controlsLayer.dominantHand = _options.dominantHand;
    
    if (_options.playBackgroundMusic)
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BackingTrack.m4a" loop:YES];
}

-(void)onExit
{
    [super onExit];
    
    if (_options.playBackgroundMusic)
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

// TODO: Haven't done a game over yet
-(void)gameOver
{
    
}

#pragma mark-
#pragma mark Game Loop

-(void)update:(float)delta
{
    if (_isGameOver) // So check for the game over condition and end if it's all done
    {
        [self gameOver];
        return;
    }
    /*
    if (_isPausing) // Check for a pause request
    {
        [self pause];
        [_controlsLayer pause];
        return;
    }*/
    
}

@end









