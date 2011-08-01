//
//  Fighter.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "FighterScene.h"
#import "Powerup.h"

extern NSString *const FighterDiedNotification;

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

-(void)shootInScene:(FighterScene *)scene;
-(void)registerHit;

-(void)decrementHealth:(int)amount;
-(void)incrementHealth:(int)amount;

-(void)getPowerup:(Powerup *)powerup;

@end
