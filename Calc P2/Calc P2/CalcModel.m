//
//  CalcModel.m
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import "CalcModel.h"
#import "CalcModelSimulator.h"

@implementation CalcModel

const double RADIAN_TO_DEGREE_CONVERSION_FACTOR = M_PI / 180;

@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;
@synthesize memoryStore = _memoryStore;
@synthesize isCalcInDegreeMode = _isCalcInDegreeMode;
@synthesize delegate = _delegate;
@synthesize waitingOperationStatus = _waitingOperationStatus;
@synthesize expression = _expression;

-(id)init
{
    if (self = [super init])
    {
        _expression = [NSMutableArray arrayWithCapacity:10];
    }
    
    return self;
}

-(double)performOperation:(NSString *)operation withScreenValueOf:(double)screenValue
{
    double previousOperand = _operand;
    // Used for the control flow for the calculation status label
    NSString *waitingOperationFormatString = nil;
    BOOL shouldAlterStatusLabel = YES;
    BOOL addOperationToExpressionList = YES;
    
    if ([operation isEqualToString:@"sqrt"])
    {
        if (_operand < 0) // Stop the error from happening
        {
            [_delegate onErrorReceived:@"The square root function does not accept negative numbers."];
            shouldAlterStatusLabel = NO; // So we won't change the status label at all
        }
        else
        {
            _operand = sqrt(self.operand);
            waitingOperationFormatString = @"sqrt(%g) =";
        }
    }
    else if ([operation isEqualToString:@"+/-"])
    {
        if (_operand != 0) // If it's 0 then +/- really does nothing
        {
            _operand = -_operand;
            waitingOperationFormatString = @"-(%g) =";
        }
    }
    else if ([operation isEqualToString:@"1/x"])
    {
        if (_operand == 0) // Stop the divide by 0 error
        {
            [_delegate onErrorReceived:@"The inverse function does not accept '0' as an argument."];
            shouldAlterStatusLabel = NO;
        }
        else
        {
            _operand = 1 / _operand;
            
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
        _operand = sin(_operand * (!_isCalcInDegreeMode ? 1 : RADIAN_TO_DEGREE_CONVERSION_FACTOR));
        waitingOperationFormatString = @"sin(%g) =";
    }
    else if ([operation isEqualToString:@"cos"])
    {
        _operand = cos(_operand * (!_isCalcInDegreeMode ? 1 : RADIAN_TO_DEGREE_CONVERSION_FACTOR));
        waitingOperationFormatString = @"cos(%g) =";
    }
    else if ([operation isEqualToString:@"C"])
    {
        [self performClear]; // Clear out the memory and tell the delegate
        addOperationToExpressionList = NO; // No need to record a clear
        [_delegate onClearOperation];
        shouldAlterStatusLabel = NO;
    }
    else if ([operation isEqualToString:@"Rec"])
    {
        self.operand = _memoryStore; // Make sure this is saved in the expression list
        addOperationToExpressionList = NO; // Since it's done in the above step
        [_delegate onMemoryRecallOperation]; // Tell the delegate this just went down
        shouldAlterStatusLabel = NO;
    }
    else if ([operation isEqualToString:@"Store"])
    {
        _memoryStore = screenValue; // Overwrite the mem value with what's on screen.
        addOperationToExpressionList = NO;
        [_delegate onStoreOperation];
        shouldAlterStatusLabel = NO;
    }
    else if ([operation isEqualToString:@"M+"])
    {
        _memoryStore += screenValue;
        addOperationToExpressionList = NO;
        [_delegate onMemoryPlusOperation];
        shouldAlterStatusLabel = NO;
    }
    else if ([operation isEqualToString:@"D/R"])
    {
        _isCalcInDegreeMode = !_isCalcInDegreeMode; // Toggle the boolean
        addOperationToExpressionList = NO;
        [_delegate onDegreeRadianOperation];
        shouldAlterStatusLabel = NO;
    }
    else // This is if we get a binary operator or equals
    {
        shouldAlterStatusLabel = NO;
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    
    // Update the operation status all things going well
    if (waitingOperationFormatString && shouldAlterStatusLabel)
        _waitingOperationStatus = [NSString stringWithFormat:waitingOperationFormatString, previousOperand];
    
    if (addOperationToExpressionList)
        [_expression addObject:operation];
    
    return self.operand;
}

-(void)performWaitingOperation
{
    double previousOperand = _operand;
    BOOL didOperationResultInError = NO;
    
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
        {
            [_delegate onErrorReceived:@"The division operator does not accept '0' as the divisor."];
            didOperationResultInError = YES;
        }
        else  _operand = self.waitingOperand / self.operand;
    }
    
    if (_waitingOperation != nil && !didOperationResultInError)
    {
        if (![_waitingOperation isEqualToString:@"="])
            _waitingOperationStatus = [NSString stringWithFormat:@"%g %@ %g = %g", _waitingOperand, _waitingOperation, previousOperand, _operand];
        _waitingOperation = nil; // Clear out the waiting operation
    }
}

// Override to add the value to our expression list
-(void)setOperand:(double)operand
{
    [_expression addObject:[NSNumber numberWithDouble:operand]];
     _operand = operand; // default behaviour
}

-(void)performClear
{
    _operand = 0;
    _waitingOperand = 0;
    _waitingOperation = @"";
    _memoryStore = 0;
    _expression = [NSMutableArray arrayWithCapacity:10]; // Reallocate the expression array
}

// Part 2 new methods

-(void)setVariableAsOperand:(NSString *) variableName
{
    [_expression addObject:variableName];
    _operand = 0; // We pretend that the variable has a value of 0 when we're typing it in.
}

+(NSSet *)variablesInExpression:(id)anExpression
{
    if (![anExpression isKindOfClass:[NSMutableArray class]])
        return nil;
    
    NSMutableArray *expressionArray = (NSMutableArray *) anExpression;
    NSMutableSet *variablesInExpression = [NSMutableSet setWithObjects:nil];
    
    for (int i = 0; i < [expressionArray count]; i++)
    {
        id expressionSegment = [expressionArray objectAtIndex:i];
        
        // If it's a number we don't care, we're only looking for the variables
        if ([expressionSegment isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *) expressionSegment;
            
            if ([string isEqualToString: @"x"])
                [variablesInExpression addObject:@"x"];
            else if ([string isEqualToString: @"a"])
                [variablesInExpression addObject:@"a"];
            else if ([string isEqualToString: @"b"])
                [variablesInExpression addObject:@"b"];
            else if ([string isEqualToString: @"c"])
                [variablesInExpression addObject:@"c"];
        }
    }
    
    return [variablesInExpression count] == 0 ? nil : variablesInExpression;
}

+(double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables withDelegate:(id <CalcModelDelegate>) delegate
{
    if (![anExpression isKindOfClass:[NSMutableArray class]])
        return NAN;
    
    NSMutableArray *expressionArray = (NSMutableArray *) anExpression;
    
    if ([expressionArray count] == 0)
        return 0; // To avoid a crash
    
    // I essentially chose to externalise the algorithm into a separate class that behaves in the same precise way as the calculator. This made sense since the interface for dealing with expressions is at the class level.
    CalcModelSimulator *simulator = [CalcModelSimulator simulatorWithDelegate:delegate];
    
    for (int i = 0; i < [expressionArray count]; i++)
    {
        id element = [expressionArray objectAtIndex:i];
        
        if ([CalcModel isValidVariable:element])
        {
            double operand = [[variables objectForKey:element] doubleValue];
            simulator.operand = operand;
        }
        else if ([element isKindOfClass:[NSString class]])
            [simulator performOperation:element];
        else if ([element isKindOfClass:[NSNumber class]])
            simulator.operand = [element doubleValue];
    }
    
    return simulator.operand;
}

+(BOOL)isValidVariable:(id)variable
{
    if (![variable isKindOfClass:[NSString class]])
        return NO;
    return [variable isEqualToString:@"a"] || [variable isEqualToString:@"b"] ||
        [variable isEqualToString:@"c"] || [variable isEqualToString:@"x"];
}

+(NSString *)descriptionOfExpression:(id)anExpression
{
    if (![anExpression isKindOfClass:[NSMutableArray class]])
        return @"'anExpression' is not a valid CalcModel expression.";
    
    NSMutableString *description = [NSMutableString stringWithCapacity:20];
    
    for (int i = 0; i < [anExpression count]; i++)
    {
        id item = [anExpression objectAtIndex:i];
        
        if ([item isKindOfClass:[NSString class]])
        {
            [description appendString:item];
            [description appendString:@" "];
        }
        else if ([item isKindOfClass:[NSNumber class]])
            [description appendString:[NSString stringWithFormat:@"%g ", [item doubleValue]]];
    }
    
    return description;
}

+(id)propertyListForExpression:(id)anExpression
{
    NSError *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:anExpression format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&error];
    
    return error != nil ? nil : plistData;
}

+(id)expressionForPropertyList:(id)propertyList
{
    NSError *error = nil;
    NSPropertyListFormat format; // Not that i need this though
    id array = [NSPropertyListSerialization propertyListWithData:propertyList options:0 format: &format error:&error];
    return error != nil ? nil : array;
}

@end







