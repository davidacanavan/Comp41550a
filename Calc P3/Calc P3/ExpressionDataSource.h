//
//  CalcModelDataSource.h
//  Calc P3
//
//  Created by David Canavan on 25/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphDataSource.h"

@interface ExpressionDataSource : NSObject <GraphDataSource>
{
    NSString *_variableName;
}

@property(nonatomic, strong) id expression;
@property(nonatomic, strong, readonly) NSMutableDictionary *variableValues;

+(id)dataSourceWithExpression:(id)expression;

@end
