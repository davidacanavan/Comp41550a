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
@synthesize isDotUsedInCurrentNumber = _isDotUsedInCurrentNumber;
@synthesize degreeRadiansDisplay = _degreeRadiansDisplay;
@synthesize binaryCalculationProgressDisplay = _binaryCalculationProgressDisplay;

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    BOOL isDigitDot = [digit isEqualToString:@"."];
    
    if(self.isInTheMiddleOfTypingSomething)
    {
        if (isDigitDot && _isDotUsedInCurrentNumber) // The user has put in two dots! Uh oh!
            return;
        
        self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
        
        if (isDigitDot) // So if we used the dot then we register it
            self.isDotUsedInCurrentNumber = YES;
    }
    else
    {
        _isDotUsedInCurrentNumber = NO; // So we start off with a clean slate and presume the user has not put in a decimal point
        
        if (isDigitDot) // Better remember this is we're in the middle of typing!
        {
            _isDotUsedInCurrentNumber = YES;
            // Then we should make the text field say '0.' if it's the first thing we type in. It makes a little more sense to the user than just a dot on its own.
            [self.calcDisplay setText:@"0."];
        }
        else
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
        self.isDotUsedInCurrentNumber = NO;
    }
    
    NSString *operation = sender.titleLabel.text;
    double result = [self.calcModel performOperation:operation];
    self.calcDisplay.text = [NSString stringWithFormat:@"%g", result];
    
    // Since if there is an error, the calculation will just return the operand we currently have. This way we can check for the error here.
    if (_calcModel.didOperationResultInError)
        [self showAlertDialogWithMessage:_calcModel.operationErrorMessage];
}

- (IBAction)otherPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    
    if ([operation isEqualToString:@"C"])
    {
        [_calcModel performClear]; // Ask the model to clear out all the internals
        _calcDisplay.text = @"0"; // Set the text of the label to 0
        _memoryDisplay.text = @"M: 0";
        self.isInTheMiddleOfTypingSomething = NO;
    }
    else if ([operation isEqualToString:@"Store"])
    {
        _calcModel.memoryStore = [_calcDisplay.text doubleValue]; // Overwrite the mem value
        _memoryDisplay.text = [NSString stringWithFormat: @"M: %g", _calcModel.memoryStore]; // Tell the memory display label to show the new value
    }
    else if ([operation isEqualToString:@"Rec"])
    {
        _calcDisplay.text = [NSString stringWithFormat:@"%g", _calcModel.memoryStore];
        _isInTheMiddleOfTypingSomething = YES;
    }
    else if ([operation isEqualToString:@"M+"])
    {
        _calcModel.memoryStore += [_calcDisplay.text doubleValue];
        _memoryDisplay.text = [NSString stringWithFormat: @"M: %g", _calcModel.memoryStore]; // Tell the memory display label to show the new value
    }
    else if ([operation isEqualToString:@"D/R"])
    {
        NSString *updatedUIText = nil;
        
        // If in radians move to degrees & vice-versa, then update the ui
        if (_calcModel.isCalcInDegreeMode) // switch to radians
        {
            _calcModel.isCalcInDegreeMode = NO;
            updatedUIText = @"Rad";
        }
        else
        {
            _calcModel.isCalcInDegreeMode = YES;
            updatedUIText = @"Deg";
        }
        
        _degreeRadiansDisplay.text = updatedUIText;
    }
    else if ([operation isEqualToString:@"Back"])
    {
        if ([_calcDisplay.text length] == 1) // Then we can't move back, but we can put it to 0
        {
            _calcDisplay.text = @"0";
            self.isInTheMiddleOfTypingSomething = NO;
        }
        else // Otherwise trim the last character off it
            _calcDisplay.text = [_calcDisplay.text substringToIndex:_calcDisplay.text.length - 1];
    }
}

// Shows the alert dialog with custom message
-(void)showAlertDialogWithMessage:(NSString *)message
{
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"Calculation Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
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

- (void)viewDidUnload {
    [self setDegreeRadiansDisplay:nil];
    [self setBinaryCalculationProgressDisplay:nil];
    [self setMemoryDisplay:nil];
    [super viewDidUnload];
}
@end
