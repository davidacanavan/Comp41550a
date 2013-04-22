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
@property(nonatomic) CGPoint axesOrigin; // points are between 0 and 1 to keep it relative to screen size
@property(nonatomic) BOOL isAxesOriginSet;

-(void)translateAxesOriginBy:(CGPoint)translation;

@end
