//
//  CalcModel.m
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import "CalcModel.h"

@implementation CalcModel

@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;

-(double)performOperation:(NSString *)operation
{
    if ([operation isEqualToString:@"sqrt"])
    {
        self.operand = sqrt(self.operand);
    }
    else if ([operation isEqualToString:@"+/-"])
    {
        self.operand = -self.operand;
    }
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

@end
