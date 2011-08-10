//
//  Fray.m
//  TauGame
//
//  Created by Ian Terrell on 8/5/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Fray.h"
#import "ClassicHorde.h"
#import "Baddie.h"
#import "Seeker.h"
#import "Arms.h"
#import "HordeUnit.h"
#import "Spinner.h"

@implementation Fray

@synthesize rows, columns, bottoms;

+(NSString *)name {
  return @"Into the Fray";
}

-(void)addBaddie {
  Baddie *baddie;
  float random = [TERandom randomFraction];
  if (random < 0.25)
    baddie = [[Arms alloc] init];
  else if (random < 0.5)
    baddie = [[Seeker alloc] init];
  else if (random < 0.75)
    baddie = [[HordeUnit alloc] initWithLevel:self row:[TERandom randomTo:rows] column:[TERandom randomTo:columns]];
  else
    baddie = [[Spinner alloc] init];
  if (![baddie isKindOfClass:[HordeUnit class]])
    baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],[TERandom randomFractionFrom:game.bottom+2 to:game.top-1]);
  else {
    baddie.maxVelocity = 3*(0.5+game.currentLevelNumber/10.0);
    baddie.velocity = GLKVector2Make(0.5+game.currentLevelNumber/10.0,-0.01+game.currentLevelNumber/100.0);
    baddie.acceleration = GLKVector2Make(game.currentLevelNumber/200.0,-1*game.currentLevelNumber/400.0);
  }
  
  [baddie setupInGame:game];
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    rows = 5;
    columns = 5;
    
    int numBaddies = 2 + game.currentLevelNumber / 5;
    for (int i = 0; i < numBaddies; i++)
      [self addBaddie];
    
    recurseEnemiesForCollisions = YES;
  }
  return self;
}

-(void)update {
  [ClassicHorde updateRowsAndColumnsForLevel:self inGame:game];
}

@end
