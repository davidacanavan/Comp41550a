//
//  DTSneakyButtonDelegate.h
//  Dead Town
//
//  Created by David Canavan on 12/03/2013.
//
//

#import <Foundation/Foundation.h>

@class SneakyButton;

@protocol DTSneakyButtonDelegate <NSObject>

-(void)buttonHoldStarted;
-(void)buttonHoldEnded;
-(void)buttonPressed;

@end
