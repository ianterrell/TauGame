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
  int numBullets;
  int spreadAmount;
}

-(void)shootInScene:(FighterScene *)scene;
-(void)registerHit;

-(void)getPowerup:(Powerup *)powerup;

@end
