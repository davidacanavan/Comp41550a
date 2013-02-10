//
//  CalcModel.h
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalcModelListener.h"

@interface CalcModel : NSObject

@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic) double memoryStore;
@property (nonatomic, strong) NSString *waitingOperation;
@property (nonatomic, readonly) BOOL didOperationResultInError;
@property (nonatomic, strong, readonly) NSString *operationErrorMessage;
@property (nonatomic) BOOL isCalcInDegreeMode;
@property (nonatomic, weak) id <CalcModelListener> listener;
@property (nonatomic, readonly) NSString *waitingOperationStatus;

-(double)performOperation:(NSString *)operation withScreenValueOf:(double)screenValue;

@end
