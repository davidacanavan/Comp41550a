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
@synthesize equalsButton = _equalsButton;

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
    double screenValue = [self.calcDisplay.text doubleValue];
    
    if(self.isInTheMiddleOfTypingSomething)
    {
        self.calcModel.operand = screenValue;
        self.isInTheMiddleOfTypingSomething = NO;
        self.isDotUsedInCurrentNumber = NO;
    }
    
    NSString *operation = sender.titleLabel.text;
    double result = [self.calcModel performOperation:operation withScreenValueOf:screenValue];
    self.calcDisplay.text = [NSString stringWithFormat:@"%g", result];
    
    _binaryCalculationProgressDisplay.text = _calcModel.waitingOperationStatus;
}

// Called when we hit the variable button
- (IBAction)setVariableAsOperand:(UIButton *)sender
{
    [_calcModel setVariableAsOperand:sender.titleLabel.text];
}

-(IBAction)solveEquation:(UIButton *)sender
{
    id expression = _calcModel.expression;
    NSSet *variablesInExpression = [CalcModel variablesInExpression:expression];
    NSMutableDictionary *variablesWithValues = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if (variablesInExpression)
    {
        double currentVariableValue = 2;
        double increaseFactor = 2;
        
        for (NSString *variableName in variablesInExpression)
        {
            [variablesWithValues setObject:[NSNumber numberWithDouble:currentVariableValue] forKey:variableName];
            currentVariableValue *= increaseFactor;
        }
    }
    
    double result = [CalcModel evaluateExpression:_calcModel.expression usingVariableValues:variablesWithValues withDelegate:self];
    self.calcDisplay.text = [NSString stringWithFormat:@"%g", result];
    
    // These lines of code check to make sure the property list methods are working correctly
    id data = [CalcModel propertyListForExpression:expression];
    id expressionFrompList = [CalcModel expressionForPropertyList:data];
    double resultCheck = [CalcModel evaluateExpression:expressionFrompList usingVariableValues:variablesWithValues withDelegate:self];
    NSLog(@"%g", result - resultCheck);
}

// I kept this action entirely seperate as it's not really an operation that the calc does
- (IBAction)backPressed:(UIButton *)sender
{
    if ([_calcDisplay.text length] == 1) // Then we can't move back, but we can put it to 0
    {
        _calcDisplay.text = @"0";
        self.isInTheMiddleOfTypingSomething = NO;
    }
    else // Otherwise trim the last character off it
        _calcDisplay.text = [_calcDisplay.text substringToIndex:_calcDisplay.text.length - 1];
}

-(void)onClearOperation // So here we just tell the UI we're putting everything to 0, the actual clearing is done by the model itself
{
    _calcDisplay.text = @"0";
    _memoryDisplay.text = @"M: 0";
    self.isInTheMiddleOfTypingSomething = NO;
}

-(void)onStoreOperation
{
    _memoryDisplay.text = [NSString stringWithFormat: @"M: %g", _calcModel.memoryStore]; // Tell the memory display label to show the new value
}

-(void)onMemoryRecallOperation // This doesn't actually effect the model
{
    //_calcDisplay.text = [NSString stringWithFormat:@"%g", _calcModel.memoryStore];
    _isInTheMiddleOfTypingSomething = YES;
}

-(void)onMemoryPlusOperation
{
    _memoryDisplay.text = [NSString stringWithFormat: @"M: %g", _calcModel.memoryStore]; // Tell the memory display label to show the new value
}

-(void)onDegreeRadianOperation
{
    _degreeRadiansDisplay.text = _calcModel.isCalcInDegreeMode ? @"Deg" : @"Rad";
}

-(void)onErrorReceived:(NSString *)errorMessage
{
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"Calculation Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _calcModel.delegate = self;
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
