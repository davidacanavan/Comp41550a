//
//  DTPlayerStatusLayer.h
//  Dead Town
//
//  Created by David Canavan on 21/02/2013.
//
//

#import "CCLayer.h"

@interface DTPlayerStatusLayer : CCLayer

@property(nonatomic) float life;
@property(nonatomic, readonly) float minLife, maxLife;

+(id)playerStatusLayerWithLife:(float)life minLife:(float)minLife maxLife:(float)maxLife;

@end
