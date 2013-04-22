
#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

-(void)drawRect:(CGRect)rect
{
    if (!_dataSource)
        return;
    
    if (!_isAxesOriginSet)
        _axesOrigin = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    // Get some stats about the bounds
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    float xCentre = width / 2, yCentre = height / 2;
    CGPoint axesShift = CGPointMake(xCentre - _axesOrigin.x, _axesOrigin.y - yCentre); // Cartesian style
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:_axesOrigin scale:_scale];
    
    // Draw the function!
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
    float xMax = (axesShift.x + width / 2) / _scale;
    float xMin = (axesShift.x -width / 2) / _scale; // Provided it's all centered
    float callStep = (xMax - xMin) / 1000; // Lets give this a high enough resolution
    
    CGPoint previous = CGPointMake(xCentre - axesShift.x + xMin * _scale, height - ([_dataSource evaluateFunctionAt:xMin] * _scale + yCentre - axesShift.y));
    //NSLog(@"Start!");
    NSLog(@"%f", axesShift.x);
    NSLog(@"%@", NSStringFromCGPoint(CGPointMake(xMin, [_dataSource evaluateFunctionAt:xMin])));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, previous.x, previous.y);
    
    for (float x = xMin + callStep; x <= xMax + 1; x += callStep)
    {
        CGPoint current = CGPointMake(xCentre - axesShift.x + x * _scale,
                                      height - ([_dataSource evaluateFunctionAt:x] * _scale + yCentre - axesShift.y));
        CGContextAddLineToPoint(context, current.x, current.y);
        previous = current;
    }
    
    CGContextStrokePath(context);
    
	UIGraphicsPopContext();
}

-(void)setScale:(float)scale
{
    _scale = scale;
    [self setNeedsDisplay];
}

-(void)setAxesOrigin:(CGPoint)axesOrigin
{
    _axesOrigin = axesOrigin;
    _isAxesOriginSet = YES;
    [self setNeedsDisplay];
}

-(void)translateAxesOriginBy:(CGPoint)translation
{
    self.axesOrigin = CGPointMake(_axesOrigin.x + translation.x,
                                  _axesOrigin.y + translation.y);
}

@end



















