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

@interface Fighter : TECharacter {
  int health, maxHealth;
  NSArray *healthShapes;
  
  int numBullets;
  int spreadAmount;
  float yRotation;
}

-(void)shootInScene:(FighterScene *)scene;
-(void)registerHit;

-(void)decrementHealth:(int)amount;
-(void)incrementHealth:(int)amount;

-(void)getPowerup:(Powerup *)powerup;

@end
