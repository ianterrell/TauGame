//
//  Powerup.h
//  TauGame
//
//  Created by Ian Terrell on 7/27/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"
#import "Game.h"

@interface Powerup : TENode

+(void)addPowerupToScene:(Game *)scene at:(GLKVector2)location;
-(void)die;

-(void)setInnerColor:(GLKVector4)inner outerColor:(GLKVector4)outer;

@end
