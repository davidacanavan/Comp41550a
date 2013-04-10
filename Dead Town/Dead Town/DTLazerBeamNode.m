//
//  LazerBeamNode.m
//  Dead Town
//
//  Created by David Canavan on 08/04/2013.
//
//

#import "DTLazerBeamNode.h"
#import "DTCharacter.h"
#import "DTMaths.h"

@implementation DTLazerBeamNode

@synthesize target = _target;

+(id)nodeWithOrigin:(DTCharacter *)origin
{
    return [[self alloc] initWithOrigin:origin];
}

-(id)initWithOrigin:(DTCharacter *)origin
{
    if (self = [super init])
    {
        // Some internal stuff
        _detail = 25;
        _thickness = 2;
        _displacement = 10;
        
        // From the input
        _origin = origin;
        self.anchorPoint = ccp(0.5, 0);
        contentSize_.height = _displacement * 2;
        self.position = [origin getPosition];
    }
    
    return self;
}

-(void)setTarget:(DTCharacter *)target
{
    _target = target;
    
    if (target) // Then we'll have to keep firing
        [self scheduleUpdate];
    else // Or we'll stop if he's out of range or dead
        [self unscheduleUpdate];
}

-(void)draw
{
    glLineWidth(_thickness);
    CGPoint points[_detail]; // Only works for odd numbers right now
    points[0] = CGPointZero;
    points[_detail - 1] = ccp(contentSize_.width, 0);
    glLineWidth(_thickness);
    generateLightning(points, 0, _detail - 1, _displacement, 1.1); // TODO: I don't need to recreate the points each time
    ccDrawPoly(points, _detail, NO);
}

void generateLightning(CGPoint points[], int start, int end, float displacement, float scale)
{
    if (abs(start - end) <= 1)
        return; // No more room left in the array
    
    int midpointIndex = (start + end) / 2;
    CGPoint midpoint = ccpMidpoint(points[start], points[end]);
    midpoint.y += ([DTMaths uniformWithLowerBound:-1 andUpperBound:1] / scale) * displacement;
    points[midpointIndex] = midpoint;
    generateLightning(points, start, midpointIndex, displacement, scale * scale);
    generateLightning(points, midpointIndex, end, displacement, scale * scale);
}

-(void)update:(ccTime)delta
{
    CGPoint origin = [_origin getPosition], target = [_target getPosition];
    contentSize_.width = ccpDistance(origin, target);
    self.position = origin;
    [self turnToFacePosition:target];
}

-(void)turnToFacePosition:(CGPoint)position
{
    // If you ever have to go through this nightmare again remember that the cocos2d sprite rotation works with an angle the positive side of the x axis as a positive angle from the easterly side of the x-axis!!!
    CGPoint spritePosition = [_origin getPosition];
    float xDifference = (float) (position.x - spritePosition.x);
    float tanToHorizontalAxis = (position.y - spritePosition.y) / ((float) xDifference); // (y2 - y1) / (x2 - x1)
    // Get the inverse tan of the ratio. Convert back to degrees. Add 180 to ensure the direction is correct!
    float bulletAngle = CC_RADIANS_TO_DEGREES(atanf(tanToHorizontalAxis));
    float angleValue = -bulletAngle;
    
    if (xDifference < 0)
        angleValue += 180;
    
    self.rotation = angleValue;
}

@end

















