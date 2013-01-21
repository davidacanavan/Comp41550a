//
//  PolygonView.m
//  HelloPoly
//
//  Created by David Canavan on 20/01/2013.
//  Copyright (c) 2013 David Canavan. All rights reserved.
//

#import "PolygonView.h"

@implementation PolygonView
@synthesize numberOfSides = _numberOfSides;

BOOL isNumberOfSidesSet = NO; // This was added as a check for myself to see in what order things ran.

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)setNumberOfSides:(int)numberOfSides
{
    _numberOfSides = numberOfSides;
    isNumberOfSidesSet = YES;
    [self setNeedsDisplay]; // Invalidate the component.
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!isNumberOfSidesSet) // So if we haven't set the number of sides yet we can just leave.
        return;
    
    NSArray *points = [PolygonView pointsForPolygonInRect:rect numberOfSides:_numberOfSides];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGPoint first = [[points objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, first.x, first.y);
    
    for (int i = 1; i < [points count]; i++)
    {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    
    CGContextAddLineToPoint(context, first.x, first.y);
    CGContextDrawPath(context, kCGPathFillStroke);
}


+ (NSArray *)pointsForPolygonInRect:(CGRect)rect numberOfSides:(int)numberOfSides
{
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    float radius = 0.9 * center.x;
    NSMutableArray *result = [NSMutableArray array];
    float angle = (2.0 * M_PI) / numberOfSides;
    float exteriorAngle = M_PI - angle;
    float rotationDelta = angle - (0.5 * exteriorAngle);
    
    for (int currentAngle = 0; currentAngle < numberOfSides; currentAngle++)
    {
        float newAngle = (angle * currentAngle) - rotationDelta;
        float curX = cos(newAngle) * radius;
        float curY = sin(newAngle) * radius;
        [result addObject:[NSValue valueWithCGPoint: CGPointMake(center.x + curX, center.y + curY)]];
    }
    
    return result;
}

@end













