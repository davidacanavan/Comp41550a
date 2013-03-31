//
//  DTLifeModel.h
//  Dead Town
//
//  Created by David Canavan on 30/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTLifeModelDelegate.h"

@interface DTLifeModel : NSObject

@property(nonatomic) float life;
@property(nonatomic, readonly) float lower;
@property(nonatomic, readonly) float upper;
@property(nonatomic) id <DTLifeModelDelegate> delegate;

+(id)lifeModelWithLife:(float)life lower:(float)lower upper:(float)upper delegate:(id <DTLifeModelDelegate>)delegate;
-(float)getPercentage;

@end
