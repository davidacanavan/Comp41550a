//
//  DTLifeModelDelegate.h
//  Dead Town
//
//  Created by David Canavan on 30/03/2013.
//
//

#import <Foundation/Foundation.h>

@class DTLifeModel;

@protocol DTLifeModelDelegate <NSObject>

-(void)lifeChangedFrom:(float)oldLife model:(DTLifeModel *)lifeModel;

@end
