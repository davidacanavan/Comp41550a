//
//  DTSneakyButtonDelegate.h
//  Dead Town
//
//  Created by David Canavan on 12/03/2013.
//
//

#import <Foundation/Foundation.h>

@class DTButton;

@protocol DTButtonDelegate <NSObject>

-(void)buttonHoldStarted:(DTButton *)button;
-(void)buttonHoldContinued:(DTButton *)button;
-(void)buttonHoldEnded:(DTButton *)button;
-(void)buttonPressed:(DTButton *)button;

@end
