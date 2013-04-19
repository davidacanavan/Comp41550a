//
//  GraphView.h
//  Calc P3
//
//  Created by David Canavan on 25/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphDataSource.h"

@interface GraphView : UIView

@property(nonatomic, strong) id <GraphDataSource> dataSource;
@property(nonatomic) float scale;

@end
