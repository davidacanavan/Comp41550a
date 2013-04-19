//
//  ViewController.h
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"
#import "CalcModelDelegate.h"

@interface ViewController : UIViewController <CalcModelDelegate>

@property (nonatomic, strong) IBOutlet CalcModel *calcModel;
@property (nonatomic, weak) IBOutlet UILabel *calcDisplay;
@property (weak, nonatomic) IBOutlet UILabel *degreeRadiansDisplay;
@property (weak, nonatomic) IBOutlet UILabel *binaryCalculationProgressDisplay;
@property (weak, nonatomic) IBOutlet UILabel *memoryDisplay;
@property (weak, nonatomic) IBOutlet UIButton *equalsButton;
@property (nonatomic) BOOL isInTheMiddleOfTypingSomething;
@property (nonatomic) BOOL isDotUsedInCurrentNumber;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)backPressed:(UIButton *)sender;
- (IBAction)setVariableAsOperand:(UIButton *)sender;
- (IBAction)solveEquation:(UIButton *)sender;

@end
