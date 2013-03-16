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
@protocol DTJoystickDelegate <NSObject>

// Called when the joystick has started to move.
-(void)joystickMoveStarted;
// Called when the joystick has stopped moving.
-(void)joystickMoveEnded;
// called when the joystick velocity has changed given the time lapse between calls.
-(void)joystickUpdated:(CGPoint)joystickVelocity delta:(float)delta;

@end

