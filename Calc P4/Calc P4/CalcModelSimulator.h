//
//  CalcModelSimulator.h
//  Calc P2
//
//  Created by David Canavan on 16/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalcModelDelegate.h"

@interface CalcModelSimulator : NSObject

@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic, strong) NSString *waitingOperation;
@property (nonatomic, strong) id <CalcModelDelegate> delegate;

+(id)simulatorWithDelegate:(id <CalcModelDelegate>)delegate;
-(double)performOperation:(NSString *)operation;

@end
