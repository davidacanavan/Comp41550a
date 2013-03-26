//
//  CalcModelDataSource.m
//  Calc P3
//
//  Created by David Canavan on 25/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import "ExpressionDataSource.h"
#import "CalcModel.h"

@implementation ExpressionDataSource

@synthesize expression = _expression;
@synthesize variableValues = _variableValues;

+(id)dataSourceWithExpression:(id)expression
{
    return [[self alloc] initWithExpression:expression];
}

-(id)initWithExpression:(id)expression
{
    if (self = [super init])
    {
        self.expression = expression;
    }
    
    return self;
}

-(void)setExpression:(id)expression
{
    _expression = expression;
    _variableValues = [NSMutableDictionary dictionaryWithCapacity:1];
    
    for (NSString *value in [CalcModel variablesInExpression:expression])
    {
        _variableName = value;
    }
}

-(double)evaluateFunctionAt:(double)x
{
    if (_variableName) // You may have a line
        [_variableValues setObject:[NSNumber numberWithDouble:x] forKey:_variableName];
    
    return [CalcModel evaluateExpression:_expression usingVariableValues:_variableValues withDelegate:nil];
}

@end









