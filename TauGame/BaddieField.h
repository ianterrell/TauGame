//
//  BaddieField.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

#import "Fighter.h"
#import "Bullet.h"
#import "Baddie.h"

@interface BaddieField : TEScene {
  Fighter *fighter;
  NSMutableArray *bullets;
  NSMutableArray *ships;
  
  TESoundManager *sounds;
}

@property(strong) NSMutableArray *bullets, *ships;

-(void)shoot;
-(void)addRandomBaddie;

@end
