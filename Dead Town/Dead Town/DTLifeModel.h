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
{
    @private
    NSMutableArray *_delegates;
}

@property(nonatomic) float life;
@property(nonatomic, readonly) float lower;
@property(nonatomic, readonly) float upper;

+(id)lifeModelWithLife:(float)life lower:(float)lower upper:(float)upper delegate:(id <DTLifeModelDelegate>)delegate;
-(float)getPercentage;
-(void)addDelegate:(id <DTLifeModelDelegate>)delegate;
-(void)removeDelegate:(id <DTLifeModelDelegate>)delegate;

@end
