
#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

- (void)drawRect:(CGRect)rect
{
    if (!_dataSource)
        return;
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)) scale:_scale];
    
    // Draw the function!
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    float xMax = width / 2 / _scale, xMin = -xMax; // Provided it's all centered
    float xCentre = width / 2, yCentre = height / 2;
    float callStep = (xMax - xMin) / 100;
    
    CGPoint previous = CGPointMake(xCentre + xMin * _scale, height - ([_dataSource evaluateFunctionAt:xMin] * _scale + yCentre));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, previous.x, previous.y);
    
    for (float x = xMin + callStep; x <= xMax + 1; x += callStep)
    {
        CGPoint current = CGPointMake(xCentre + x * _scale,
            height - ([_dataSource evaluateFunctionAt:x] * _scale + yCentre));
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

@end







