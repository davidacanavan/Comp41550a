//
//  GraphViewController.h
//  Calc P3
//
//  Created by David Canavan on 25/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController

@property(nonatomic, strong) id expression;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
- (IBAction)zoomInButtonPressed:(UIButton *)sender;
- (IBAction)zoomOutButtonPressed:(UIButton *)sender;

@end
