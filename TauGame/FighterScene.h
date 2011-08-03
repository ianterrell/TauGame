//
//  FighterScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

#import "Bullet.h"

@class Fighter;

@interface FighterScene : TEScene {
  Fighter *fighter;
  NSMutableArray *bullets, *powerups, *lives, *shotTimers;
  TECharacter *scoreboard;

  TESoundManager *sounds;
}

@property(strong) Fighter *fighter;
@property(strong) NSMutableArray *bullets, *powerups;

-(void)incrementScore:(int)score;
-(void)incrementScoreWithPulse:(int)score;

-(void)addLifeDisplayAtIndex:(int)i;
-(void)addShotTimerAtIndex:(int)i;

-(void)dropPowerupWithPercentChance:(float)percent at:(GLKVector2)position;
-(void)addBulletSplashAt:(GLKVector2)position;

-(void)exit;

@end
