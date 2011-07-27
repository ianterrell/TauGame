//
//  Fighter.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECharacter.h"
#import "TEAdjustedAttitude.h"
#import "FighterScene.h"

@interface Fighter : TECharacter {
  TEAdjustedAttitude *attitude;
  int numBullets;
  int spreadAmount;
}

-(void)shootInScene:(FighterScene *)scene;
-(void)registerHit;

@end
