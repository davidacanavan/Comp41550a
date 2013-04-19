//
//  CalcModelSimulator.m
//  Calc P2
//
//  Created by David Canavan on 16/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import "CalcModelSimulator.h"

@implementation CalcModelSimulator

@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;
@synthesize delegate = _delegate;

+(id)simulatorWithDelegate:(id<CalcModelDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}

-(id)initWithDelegate:(id<CalcModelDelegate>)delegate
{
    if (self = [super init])
    {
        _delegate = delegate;
    }
    
    return self;
}

-(double)performOperation:(NSString *)operation
{
    if ([operation isEqualToString:@"sqrt"])
    {
        if (_operand < 0)
            [_delegate onErrorReceived:@"Expression error: Cannot take the square root of a negative number!"];
        else
            _operand = sqrt(self.operand);
    }
    else if ([operation isEqualToString:@"+/-"])
        _operand = -_operand;
    else if ([operation isEqualToString:@"1/x"])
    {
        if (_operand == 0)
            [_delegate onErrorReceived:@"Expression error: The inverse function does not accept '0' as an argument."];
        else
            _operand = 1 / _operand;
    }
    else if ([operation isEqualToString:@"sin"])
        _operand = sin(_operand);
    else if ([operation isEqualToString:@"cos"])
        _operand = cos(_operand);
    else // This is if we get a binary operator or equals
    {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    return self.operand;
}

-(void)performWaitingOperation
{
    // Don't use the overridden setter here since we don't need to record the operation
    if ([@"+" isEqualToString:self.waitingOperation])
        _operand = self.waitingOperand + self.operand;
    else if ([@"-" isEqualToString:self.waitingOperation])
        _operand = self.waitingOperand - self.operand;
    else if ([@"*" isEqualToString:self.waitingOperation])
        _operand = self.waitingOperand * self.operand;
    else if ([@"/" isEqualToString:self.waitingOperation])
    {
        if (_operand == 0)
            [_delegate onErrorReceived:@"Expression error: The division operator does not accept '0' as the divisor."];
        else _operand = self.waitingOperand / self.operand;
    }
}


@end
