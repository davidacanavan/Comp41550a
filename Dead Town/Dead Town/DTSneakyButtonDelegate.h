//
//  DTSneakyButtonDelegate.h
//  Dead Town
//
//  Created by David Canavan on 12/03/2013.
//
//

#import <Foundation/Foundation.h>

@class DTSneakyButton;

@protocol DTSneakyButtonDelegate <NSObject>

-(void)buttonHoldStarted:(DTSneakyButton *)button;
-(void)buttonHoldContinued:(DTSneakyButton *)button;
-(void)buttonHoldEnded:(DTSneakyButton *)button;
-(void)buttonPressed:(DTSneakyButton *)button;

@end
