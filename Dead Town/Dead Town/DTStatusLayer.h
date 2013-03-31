//
//  DTPlayerStatusLayer.h
//  Dead Town
//
//  Created by David Canavan on 21/02/2013.
//
//

#import "CCLayer.h"

@class DTLifeNode;

@interface DTStatusLayer : CCLayer

@property(nonatomic) float life;
@property(nonatomic, readonly) float minLife, maxLife;
@property(nonatomic, readonly) DTLifeNode *lifeNode;

+(id)statusLayerWithLife:(float)life minLife:(float)minLife maxLife:(float)maxLife;

@end
