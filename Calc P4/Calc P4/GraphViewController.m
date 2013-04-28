//
//  GraphViewController.m
//  Calc P3
//
//  Created by David Canavan on 25/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import "GraphViewController.h"
#import "ExpressionDataSource.h"
#import "CalcModel.h"

#define SCALE_CHANGE_FACTOR 0.2;

@implementation GraphViewController

@synthesize expression = _expression;
@synthesize graphView = _graphView;

-(void)viewDidLoad // This is called from the iPhone push since it's recreated each time
{
    // Register the quit listener and get the old graph if we had one
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    BOOL isPreviousStateLoaded = [self loadPreviousStateIfApplicable];
    
    if (!isIPad) // Only do this for iphone or else we get an error string as the title
    {
        NSString *description = [CalcModel descriptionOfExpression:_expression];
        self.navigationItem.title = description;
        self.navigationItem.backBarButtonItem.title = @"Back";
    }
    else if (isPreviousStateLoaded)
    {
        NSString *description = [CalcModel descriptionOfExpression:_expression];
        self.navigationItem.title = description;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else
        self.navigationItem.leftBarButtonItem = nil; // So we nil it out be we have a strong ref to it - keep it hidden by default (bit of an API fix)
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        self.navigationItem.leftBarButtonItem = _barButton;
    }
    
    _scaleChangeUntilWeAllowAPinch = 2;
    _currentScaleChangeUntilWeAllowAPinch = 0;
}

-(BOOL)loadPreviousStateIfApplicable
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id propertyList = [defaults objectForKey:@"previous_expression"];
    id previousExpression = nil;
    
    if (propertyList) // In case it's nil, we don't want a crash later on the NSData*
        previousExpression = [CalcModel expressionForPropertyList:propertyList];
    
    _expression = _expression == nil ? previousExpression : _expression; // So if we already have an expression lets use that. If not get the old one! Doesn't matter if they're both null, then nothing will happen.
    
    _graphView.dataSource = [ExpressionDataSource dataSourceWithExpression:_expression];
    
    // Get the values we have, floats are stored as 0 if they are unset
    float scale = [defaults floatForKey:@"scale"];
    float axisOriginX = [defaults floatForKey:@"axis_origin_x"];
    float axisOriginY = [defaults floatForKey:@"axis_origin_y"];
    
    // See if we can assign them
    _graphView.scale = scale == 0 ? 1 : scale;
    
    if (axisOriginX != 0 && axisOriginY != 0) // If not they're centered by the GraphView.
        _graphView.axesOrigin = CGPointMake(axisOriginX, axisOriginY);
    
    return _expression == previousExpression;
}

-(void)handleDidEnterBackgroundNotification:(NSNotification *)notification
{
    id propertyList = [CalcModel propertyListForExpression:_expression];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:propertyList forKey:@"previous_expression"];
    [defaults setFloat:_graphView.scale forKey:@"scale"];
    [defaults setFloat:_graphView.axesOrigin.x forKey:@"axis_origin_x"];
    [defaults setFloat:_graphView.axesOrigin.y forKey:@"axis_origin_y"];
    [defaults synchronize];
}

-(void)reloadCurrentExpressionToGraphView // This is called manually in the iPad version to reload
{
    _graphView.dataSource = [ExpressionDataSource dataSourceWithExpression:_expression];
    _graphView.scale = 1; // Reset the scale... this is on purpose, i think new graphs should be scale-reset
    self.navigationItem.title = [CalcModel descriptionOfExpression:_expression];
    [_graphView setNeedsDisplay]; // And repaint
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setBarButton:nil]; // Make sure to nil it out here since i keep a strong ref to it
    [super viewDidUnload];
}

- (IBAction)barButtonPressed:(UIBarButtonItem *)sender
{
    if (!_popover)
    {
        UIViewController *calculatorViewController = [self.splitViewController.viewControllers objectAtIndex:0];
        _popover = [[UIPopoverController alloc] initWithContentViewController:calculatorViewController];
    }
    
    [_popover presentPopoverFromBarButtonItem:_barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)zoomInBy:(float)changeInFactor
{
    _graphView.scale = fminf(_graphView.scale + changeInFactor, 4);
}

-(void)zoomOutBy:(float)changeInFactor
{
    _graphView.scale = fmaxf(_graphView.scale - changeInFactor, .2);
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) ||
                interfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_graphView setNeedsDisplay];
    
    // Show or hide the bar button
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        self.navigationItem.leftBarButtonItem = _barButton;
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        [_popover dismissPopoverAnimated:NO];
    }
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender
{
    if (sender.velocity > 0)
        [self zoomInBy:.01]; // This factor seemed to give a nice flow to the pinch
    else
        [self zoomOutBy: .01];

}

// Responds to double tap only - woohoo!
- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    _graphView.isAxesOriginSet = NO; // We essentially move the axes back to the centre point
    [_graphView setNeedsDisplay];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:_graphView];
    CGPoint scaled = CGPointMake(translation.x / 5, translation.y / 5); // Reduce the sensitivity of the translation a bit so it's not so jerky
    [_graphView translateAxesOriginBy:scaled];
}

@end



















