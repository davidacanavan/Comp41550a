//
//  Trigger.m
//  Dead Town
//
//  Created by David Canavan on 11/04/2013.
//
//

#import "DTTrigger.h"

@implementation DTTrigger

@synthesize name = _name;
@synthesize rect = _rect;

+(id)triggerWithName:(NSString *)name andRect:(CGRect)rect
{
    return [[self alloc] initWithName:name andRect:rect];
}

-(id)initWithName:(NSString *)name andRect:(CGRect)rect
{
    if (self = [super init])
    {
        self.name = name;
        self.rect = rect;
    }
    
    return self;
}

@end
