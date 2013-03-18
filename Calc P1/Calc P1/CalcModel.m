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
@synthesize delegate = _delegate;
@synthesize waitingOperationStatus = _waitingOperationStatus;

-(double)performOperation:(NSString *)operation withScreenValueOf:(double)screenValue
{
    double previousOperand = _operand;
    // Used for the control flow for the calculation status label
    NSString *waitingOperationFormatString = nil;
    BOOL shouldAlterStatusLabel = YES;
    
    if ([operation isEqualToString:@"sqrt"])
    {
        if (self.operand < 0) // Stop the error from happening
        {
            [_delegate onErrorReceived:@"The square root function does not accept negative numbers."];
            shouldAlterStatusLabel = NO; // So we won't change the status label at all
        }
        else
        {
            self.operand = sqrt(self.operand);
            waitingOperationFormatString = @"sqrt(%g) =";
        }
    }
    else if ([operation isEqualToString:@"+/-"])
    {
        if (self.operand != 0) // If it's 0 then +/- really does nothing
        {
            self.operand = -self.operand;
            waitingOperationFormatString = @"-(%g) =";
        }
    }
    else if ([operation isEqualToString:@"1/x"])
    {
        if (self.operand == 0) // Stop the divide by 0 error
        {
            [_delegate onErrorReceived:@"The inverse function does not accept '0' as an argument."];
            shouldAlterStatusLabel = NO;
        }
        else
        {
            self.operand = 1 / self.operand;
            
            if (previousOperand < 0) // Then we format a bit differently
            {
                waitingOperationFormatString = @"-1/%g =";
                previousOperand = -previousOperand;
            }
            else
                waitingOperationFormatString = @"1/%g =";
        }
    }
    else if ([operation isEqualToString:@"sin"])
    {
        self.operand = sin(self.operand * (!_isCalcInDegreeMode ? 1 : RADIAN_TO_DEGREE_CONVERSION_FACTOR));
        waitingOperationFormatString = @"sin(%g) =";
    }
    else if ([operation isEqualToString:@"cos"])
    {
        self.operand = cos(self.operand * (!_isCalcInDegreeMode ? 1 : RADIAN_TO_DEGREE_CONVERSION_FACTOR));
        waitingOperationFormatString = @"cos(%g) =";
    }
    else if ([operation isEqualToString:@"C"])
    {
        [self performClear]; // Clear out the memory and tell the listener
        [_delegate onClearOperation];
    }
    else if ([operation isEqualToString:@"Rec"])
    {
        _operand = _memoryStore;
        [_delegate onMemoryRecallOperation]; // Tell the listener this just went down
    }
    else if ([operation isEqualToString:@"Store"])
    {
        _memoryStore = screenValue; // Overwrite the mem value with what's on screen.
        [_delegate onStoreOperation];
    }
    else if ([operation isEqualToString:@"M+"])
    {
        _memoryStore += screenValue;
        [_delegate onMemoryPlusOperation];
    }
    else if ([operation isEqualToString:@"D/R"])
    {
        _isCalcInDegreeMode = !_isCalcInDegreeMode; // Toggle the boolean
        [_delegate onDegreeRadianOperation];
    }
    else // This is if we get a binary operator or equals
    {
        shouldAlterStatusLabel = NO; // So we'll let the other function take care of the waiting status
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    // Update the operation status all things going well
    if (waitingOperationFormatString && shouldAlterStatusLabel)
        _waitingOperationStatus = [NSString stringWithFormat:waitingOperationFormatString, previousOperand];
    return self.operand;
}

-(void)performWaitingOperation
{
    double previousOperand = _operand;
    BOOL didOperationResultInError = NO;
    
    if ([@"+" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand + self.operand;
    else if ([@"-" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand - self.operand;
    else if ([@"*" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand * self.operand;
    else if ([@"/" isEqualToString:self.waitingOperation])
    {
        if (self.operand == 0)
        {
            [_delegate onErrorReceived:@"The division operator does not accept '0' as the divisor."];
            didOperationResultInError = YES;
        }
        else self.operand = self.waitingOperand / self.operand;
    }
    
    if (_waitingOperation != nil && !didOperationResultInError)
    {
        if (![_waitingOperation isEqualToString:@"="])
            _waitingOperationStatus = [NSString stringWithFormat:@"%g %@ %g = %g", _waitingOperand, _waitingOperation, previousOperand, _operand];
        _waitingOperation = nil; // Clear out the waiting operation
    }
}

-(void)performClear
{
    _operand = 0;
    _waitingOperand = 0;
    _waitingOperation = nil;
    _waitingOperationStatus = nil;
    _memoryStore = 0;
}

-(void)registerOperationError:(NSString *)message
{
    _operationErrorMessage = message;
    _didOperationResultInError = YES;
}


@end
