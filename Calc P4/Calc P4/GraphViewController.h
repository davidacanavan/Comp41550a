//
//  GraphViewController.h
//  Calc P3
//
//  Created by David Canavan on 25/03/2013.
//  Copyright (c) 2013 ie.ucd.csi.comp41550. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

#define isIPad ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))

@interface GraphViewController : UIViewController
{
    @private
    UIPopoverController *_popover;
    float _scaleChangeUntilWeAllowAPinch;
    float _currentScaleChangeUntilWeAllowAPinch;
}

@property(nonatomic, strong) id expression;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property(nonatomic, strong) IBOutlet UIBarButtonItem *barButton; // Make this strong so it wont dealloc when i try to hide it by setting the ref to nil in the parent
- (IBAction)barButtonPressed:(UIBarButtonItem *)sender;
- (void)reloadCurrentExpressionToGraphView;
// Gesture recogniser methods
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender;
- (IBAction)handleTap:(UITapGestureRecognizer *)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;

@end
