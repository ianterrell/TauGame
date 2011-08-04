//
//  Fighter.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "Game.h"
#import "Powerup.h"

extern NSString *const FighterDiedNotification;
extern NSString *const FighterExtraLifeNotification;
extern NSString *const FighterExtraShotNotification;

@interface Fighter : TECharacter {
  BOOL paused;
  
  int health, maxHealth, lives;
  NSArray *healthShapes;
  
  int numShots, numBullets, spreadAmount;
  float shotSpeed;
  
  float yRotation;
  
  TENode *body;
  
  NSMutableArray *shotTimers;
}

@property int lives, numShots;
@property(strong,nonatomic) NSMutableArray *shotTimers;

-(BOOL)dead;
-(BOOL)gameOver;

-(void)shootInScene:(Game *)scene;
-(void)registerHit;

-(void)decrementHealth:(int)amount;
-(void)incrementHealth:(int)amount;

-(void)getPowerup:(Powerup *)powerup;
-(void)addExtraShot;

@end
