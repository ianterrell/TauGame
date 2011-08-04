//
//  Powerup.h
//  TauGame
//
//  Created by Ian Terrell on 7/27/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECharacter.h"
#import "Game.h"

@interface Powerup : TECharacter

+(void)addPowerupToScene:(Game *)scene at:(GLKVector2)location;
-(void)die;

-(void)setInnerColor:(GLKVector4)inner outerColor:(GLKVector4)outer;

@end
