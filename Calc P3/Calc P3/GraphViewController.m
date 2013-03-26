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

-(void)viewDidLoad
{
    _graphView.dataSource = [ExpressionDataSource dataSourceWithExpression:_expression];
    _graphView.scale = 1;
    NSString *description = [CalcModel descriptionOfExpression:_expression];
    self.navigationItem.title = description;
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [super viewDidUnload];
}
- (IBAction)zoomInButtonPressed:(UIButton *)sender
{
    _graphView.scale = fminf(_graphView.scale + .2, 4);
}

- (IBAction)zoomOutButtonPressed:(UIButton *)sender
{
    _graphView.scale = fmaxf(_graphView.scale - .2, .2);
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation) ||
                interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end








