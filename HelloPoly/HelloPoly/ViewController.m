//
//  ViewController.m
//  HelloPoly
//
//  Created by David Canavan on 16/01/2013.
//  Copyright (c) 2013 David Canavan. All rights reserved.
//

#import "ViewController.h"
#import "PolygonView.h"

@implementation ViewController
@synthesize numberOfSidesLabel = _numberOfSidesLabel;
@synthesize numberOfSides = _numberOfSides;
@synthesize model = _model;
@synthesize polygonView = _polygonView;
@synthesize polygonTitle = _polygonTitle;
@synthesize increaseButton = _increaseButton;
@synthesize decreaseButton = _decreaseButton;

- (void)updateNumberOfSides:(int)sides isDecreasing:(BOOL)isDecreasing
{
    int min = _model.minNumberOfSides, max = _model.maxNumberOfSides;
    
    // Update the MVC framework
    _model.numberOfSides = sides;
    _numberOfSidesLabel.text = [NSString stringWithFormat: @"%d", sides];
    _polygonTitle.text = _model.name;
    _polygonView.numberOfSides = sides;
    
    // Enable.disable the buttons if we need to
    
    if (sides == min)
        [_decreaseButton setEnabled:NO];
    else if (sides == max)
        [_increaseButton setEnabled:NO];
    
    if (isDecreasing)
        [_increaseButton setEnabled:YES];
    else
        [_decreaseButton setEnabled:YES];
    
    
    // Save the change in the defaults - I put this here to do things on the fly, i guess in a real app i'd hate to have all saves up in the app delegates terminating method, it could get messy.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sides forKey:@"saved_number_of_size"];
    [defaults synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int value = [[NSUserDefaults standardUserDefaults] integerForKey:@"saved_number_of_size"];
    int sides;
    
    if (value == 0) // So if the value was never set then we get it from the IB which was 5
        sides = [_numberOfSidesLabel.text intValue];
    else // Or get it from the defaults
        sides = value;
    
    [self updateNumberOfSides:sides isDecreasing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)decrease:(UIButton *)sender
{
    int min = [_model minNumberOfSides];
    int value = [_numberOfSidesLabel.text intValue];
    
    if (value == min)
        return;
    
    value--;
    [self updateNumberOfSides: value isDecreasing:YES];
}

- (IBAction)increase:(UIButton *)sender
{
    int max = [_model maxNumberOfSides];
    int value = [_numberOfSidesLabel.text intValue];
    
    if (value == max)
        return;
    
    value++;
    [self updateNumberOfSides: value isDecreasing:NO];
}

- (void)viewDidUnload
{
    [self setNumberOfSidesLabel:nil];
    [self setModel:nil];
    [self setPolygonView:nil];
    [self setPolygonTitle:nil];
    [self setIncreaseButton:nil];
    [self setDecreaseButton:nil];
    [super viewDidUnload];
}

@end






