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
    _graphView.dataSource = [ExpressionDataSource dataSourceWithExpression:_expression];
    _graphView.scale = 1;
    
    if (!isIPad) // Only do this for iphone or else we get an error string as the title
    {
        NSString *description = [CalcModel descriptionOfExpression:_expression];
        self.navigationItem.title = description;
        self.navigationItem.backBarButtonItem.title = @"Back";
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

-(void)reloadCurrentExpressionToGraphView // This is called manually in the iPad version to reload
{
    _graphView.dataSource = [ExpressionDataSource dataSourceWithExpression:_expression];
    _graphView.scale = 1; // Reset the scale...
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

- (IBAction)zoomInButtonPressed:(UIButton *)sender
{
    [self zoomIn];
}

-(void)zoomIn
{
    _graphView.scale = fminf(_graphView.scale + .2, 4);
}

- (IBAction)zoomOutButtonPressed:(UIButton *)sender
{
    [self zoomOut];
}

-(void)zoomOut
{
    _graphView.scale = fmaxf(_graphView.scale - .2, .2);
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
    _currentScaleChangeUntilWeAllowAPinch += sender.scale;
    
    if (fabsf(_currentScaleChangeUntilWeAllowAPinch) > _scaleChangeUntilWeAllowAPinch)
    {
        if (sender.velocity > 0)
            [self zoomIn];
        else
            [self zoomOut];
        
        _currentScaleChangeUntilWeAllowAPinch = 0;
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.numberOfTouches != 1)
        return;
    
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
}

@end



















