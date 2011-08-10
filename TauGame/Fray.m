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
    int numHorde = MIN(12,2 + (game.currentLevelNumber-1)/2);
//    int numArms = game.currentLevelNumber > 12 ? 2 : 1;
//    int numSeekers = game.currentLevelNumber < 5 ? 0 : game.currentLevelNumber < 17 ? 1 : 2;
//    int numSpinners = game.currentLevelNumber < 9 ? 0 : game.currentLevelNumber < 21 ? 1 : 2;
    
    // Setup horde
    rows = game.currentLevelNumber < 7 ? 1 : game.currentLevelNumber < 15 ? 2 : 3;
    columns = game.currentLevelNumber < 3 ? 3 : game.currentLevelNumber < 5 ? 5 : game.currentLevelNumber < 13 ? 7 : 8;
    
    bottoms = [NSMutableArray arrayWithCapacity:columns];
    
    int hordeCount = 0;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        id baddie = [NSNull null];
        if (row % 2 == col % 2) {
          if (hordeCount < numHorde) {
            baddie = [[ClassicHorde class] addHordeUnitForLevel:self atRow:row column:col];
            hordeCount++;
          }
        }
        if (row == 0) // initialize bottoms
          [bottoms addObject:baddie];
        else if ([baddie isKindOfClass:[HordeUnit class]]) // keep bottoms up to date
          [bottoms replaceObjectAtIndex:col withObject:baddie];
      }
    }
    
    recurseEnemiesForCollisions = YES;
  }
  return self;
}

-(void)update {
  [ClassicHorde updateRowsAndColumnsForLevel:self inGame:game];
}

@end
