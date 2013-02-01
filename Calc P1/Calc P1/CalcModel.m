//
//  CalcModel.m
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import "CalcModel.h"

@implementation CalcModel

const double RADIAN_TO_DEGREE_CONVERSION_FACTOR = M_PI / 180;

@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;
@synthesize memoryStore = _memoryStore;
@synthesize didOperationResultInError = _didOperationResultInError;
@synthesize operationErrorMessage = _operationErrorMessage;
@synthesize isCalcInDegreeMode = _isCalcInDegreeMode;

-(double)performOperation:(NSString *)operation
{
    _didOperationResultInError = NO; // initially assume we haven't had a calcultion error
    
    if ([operation isEqualToString:@"sqrt"])
    {
        if (self.operand < 0) // Stop the error from happening
            [self registerOperationError:@"The square root function does not accept negative numbers."];
        else
            self.operand = sqrt(self.operand);
    }
    else if ([operation isEqualToString:@"+/-"])
    {
        if (self.operand != 0) // If it's 0 then +/- really does nothing
            self.operand = -self.operand;
    }
    else if ([operation isEqualToString:@"1/x"])
    {
        if (self.operand == 0) // Stop the divide by 0 error
            [self registerOperationError:@"The inverse function does not accept '0' as an argument."];
        else
            self.operand = 1 / self.operand;
    }
    else if ([operation isEqualToString:@"sin"])
        self.operand = sin(self.operand * (!_isCalcInDegreeMode ? 1 : RADIAN_TO_DEGREE_CONVERSION_FACTOR));
    else if ([operation isEqualToString:@"cos"])
        self.operand = cos(self.operand * (!_isCalcInDegreeMode ? 1 : RADIAN_TO_DEGREE_CONVERSION_FACTOR));
    else
    {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    return self.operand;
}

-(void)performWaitingOperation
{
    if([@"+" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand + self.operand;
    else if([@"-" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand - self.operand;
    else if([@"*" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand * self.operand;
    else if([@"/" isEqualToString:self.waitingOperation])
        if(self.operand) self.operand = self.waitingOperand / self.operand;
}

-(void)performClear
{
    _operand = 0;
    _waitingOperand = 0;
    _waitingOperation = @"";
    _memoryStore = 0;
}

-(void)registerOperationError:(NSString *)message
{
    _operationErrorMessage = message;
    _didOperationResultInError = YES;
}

@end
