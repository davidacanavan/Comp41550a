#import <Foundation/Foundation.h>

@interface PolygonShape : NSObject

@property (nonatomic) int numberOfSides;
@property (readonly, weak) NSString *name;

- (id) initWithNumberOfSides: (int)sides;
- (int) minNumberOfSides;
- (int) maxNumberOfSides;

@end