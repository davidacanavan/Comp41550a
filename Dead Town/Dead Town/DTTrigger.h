//
//  Trigger.h
//  Dead Town
//
//  Created by David Canavan on 11/04/2013.
//
//

#import <Foundation/Foundation.h>

@interface DTTrigger : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) CGRect rect;

+(id)triggerWithName:(NSString *)name andRect:(CGRect)rect;

@end
