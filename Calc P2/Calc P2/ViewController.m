//
//  ViewController.m
//  Calc Part 1
//
//  Created by David Canavan on 31/01/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;
@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    
    if(self.isInTheMiddleOfTypingSomething)
        self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
    else
    {
        [self.calcDisplay setText:digit];
        self.isInTheMiddleOfTypingSomething = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if(self.isInTheMiddleOfTypingSomething)
    {
        self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    
    NSString *operation = sender.titleLabel.text;
    double result = [self.calcModel performOperation:operation];
    self.calcDisplay.text = [NSString stringWithFormat:@"%g", result];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
