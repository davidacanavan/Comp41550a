//
//  ViewController.h
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet CalcModel *calcModel;
@property (nonatomic, weak) IBOutlet UILabel *calcDisplay;
@property (nonatomic) BOOL isInTheMiddleOfTypingSomething;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;

@end
