//
//  FighterScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@class Fighter, GameLevel;

@interface Game : TEScene {
  GameLevel *currentLevel;
  int currentLevelNumber;
  
  Fighter *fighter;
  
  NSMutableArray *powerups, *lives, *shotTimers;
  NSMutableArray *bullets, *enemies, *enemyBullets;

  TENode *scoreboard;
}

@property(readonly) int currentLevelNumber;
@property(strong) Fighter *fighter;
@property(strong) NSMutableArray *bullets, *powerups, *enemies, *enemyBullets;

# pragma mark - Levels

-(void)loadNextLevel;

# pragma mark - Score

-(void)incrementScore:(int)score;
-(void)incrementScoreWithPulse:(int)score;

# pragma mark - HUD

-(void)addLifeDisplayAtIndex:(int)i;
-(void)addShotTimerAtIndex:(int)i;

# pragma mark - Powerups

-(void)dropPowerupWithPercentChance:(float)percent at:(GLKVector2)position;

#pragma mark - Effects

-(void)addBulletSplashAt:(GLKVector2)position;

# pragma mark - Scene Transitioning

-(void)exit;

@end
