//
//  DTLifeModelDelegate.h
//  Dead Town
//
//  Created by David Canavan on 30/03/2013.
//
//

#import <Foundation/Foundation.h>

@class DTLifeModel;
@class DTCharacter;

@protocol DTLifeModelDelegate <NSObject>

-(void)lifeChangedFrom:(float)oldLife model:(DTLifeModel *)lifeModel character:(DTCharacter *)character;

@end
