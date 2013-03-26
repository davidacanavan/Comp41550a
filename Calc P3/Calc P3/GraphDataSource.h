//
//  GraphDataSource.h
//  Calc P3
//
//  Created by David Canavan on 25/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GraphDataSource <NSObject>

-(double)evaluateFunctionAt:(double)x;

@end
