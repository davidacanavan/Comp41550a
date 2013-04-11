//
//  DTLifeModel.h
//  Dead Town
//
//  Created by David Canavan on 30/03/2013.
//
//

#import <Foundation/Foundation.h>
#import "DTLifeModelDelegate.h"

@class DTCharacter;

@interface DTLifeModel : NSObject
{
    @private
    NSMutableArray *_delegates;
}

@property(nonatomic) float life;
@property(nonatomic, readonly) float lower;
@property(nonatomic, readonly) float upper;
@property(nonatomic, readonly) DTCharacter *character;

+(id)lifeModelWithLife:(float)life lower:(float)lower upper:(float)upper delegate:(id <DTLifeModelDelegate>)delegate character:(DTCharacter *) character;
-(float)getPercentage;
-(BOOL)isZero;
-(void)addDelegate:(id <DTLifeModelDelegate>)delegate;
-(void)removeDelegate:(id <DTLifeModelDelegate>)delegate;

@end
