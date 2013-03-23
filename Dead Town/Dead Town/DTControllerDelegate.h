//
//  DTControlsListener.h
//  Dead Town
//
//  Created by David Canavan on 11/03/2013.
//
//

#import <Foundation/Foundation.h>

// General callbacks for dealing with the various buttons and joystick/tilt controls.
// The methods beginning with joystick supply velocity vectors from both tilt controls and the joystick.
@protocol DTControllerDelegate <NSObject>

// Called when the joystick has started to move.
-(void)controllerMoveStarted;
// Called when the joystick has stopped moving.
-(void)controllerMoveEnded;
// called when the joystick velocity has changed given the time lapse between calls.
-(void)controllerUpdated:(CGPoint)velocity delta:(float)delta;

@end

