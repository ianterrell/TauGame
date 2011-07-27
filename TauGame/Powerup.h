//
//  Powerup.h
//  TauGame
//
//  Created by Ian Terrell on 7/27/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECharacter.h"
#import "FighterScene.h"

@interface Powerup : TECharacter

+(void)addPowerupToScene:(FighterScene *)scene at:(GLKVector2)location;
-(void)die;

@end
