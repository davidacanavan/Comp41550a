//
//  CalcModelListener.h
//  Calc P1
//
//  Created by David Canavan on 03/02/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CalcModelListener

-(void)onClearOperation;
-(void)onStoreOperation;
-(void)onMemoryRecallOperation;
-(void)onMemoryPlusOperation;
-(void)onDegreeRadianOperation;

@end
