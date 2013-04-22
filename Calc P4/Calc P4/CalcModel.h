//
//  CalcModel.h
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalcModelDelegate.h"

@interface CalcModel : NSObject

@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic) double memoryStore;
@property (nonatomic, strong) NSString *waitingOperation;
@property (nonatomic) BOOL isCalcInDegreeMode;
@property (nonatomic, weak) id <CalcModelDelegate> delegate;
@property (nonatomic, readonly) NSString *waitingOperationStatus;
@property (readonly, strong) id expression; // New property in P2

// P1 methods
- (double)performOperation:(NSString *)operation withScreenValueOf:(double)screenValue;

// P2 methods
- (id)init;
- (void)setVariableAsOperand:(NSString *)variableName;
// I added a delegate option at the back of this so we can still receive error messages
+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables withDelegate:(id <CalcModelDelegate>)delegate;
+ (NSSet *)variablesInExpression:(id) anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;
// P4 new methods!
- (void)writeStateToUserDefaults:(NSUserDefaults *)defaults;
- (void)readStateFromUserDefaults:(NSUserDefaults *)defaults;


@end
