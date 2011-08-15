//
//  Sfx.h
//  TauGame
//
//  Created by Ian Terrell on 8/15/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sfx : NSObject

+(void)shoot;
+(void)hurt;
+(void)die;
+(void)resurrect;
+(void)baddieShoot;
+(void)baddieDrop;
+(void)baddieInvulnerable;
+(void)baddieHurt;
+(void)baddieDie;
+(void)scoreBonus;
+(void)powerup;

@end
