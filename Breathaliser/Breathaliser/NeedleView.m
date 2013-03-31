//
//  NeedleView.m
//  Breathaliser
//
//  Created by David Canavan on 26/03/2013.
//  Copyright (c) 2013 thumbs up. All rights reserved.
//

#import "NeedleView.h"

@implementation NeedleView

-(void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(c);
    
    CGPoint pinRotationPoint = CGPointMake(rect.size.width / 2, rect.size.height * .2);
    CGFloat length = rect.size.height * .7;
    //CGFloat angle = 0;
    CGContextSetStrokeColorWithColor(<#CGColorRef color#>)(c, );
    CGPoint endPoint = CGPointMake(pinRotationPoint.x, pinRotationPoint.y + length);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, pinRotationPoint.x, pinRotationPoint.y);
    CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
    CGContextStrokePath(c);
    UIGraphicsPopContext();
}

@end
