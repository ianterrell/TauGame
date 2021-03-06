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
    int numArms = game.currentLevelNumber > 12 ? 2 : 1;
    int numSeekers = game.currentLevelNumber < 5 ? 0 : game.currentLevelNumber < 17 ? 1 : 2;
    int numSpinners = game.currentLevelNumber < 9 ? 0 : game.currentLevelNumber < 21 ? 1 : 2;
    
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
    
    // Setup arms
    for (int i = 0; i < numArms; i++) {
      Arms *baddie = [[Arms alloc] init];
      baddie.shotDelayMin = MAX(FRAY_ARMS_SHOT_DELAY_MIN_MIN,FRAY_ARMS_SHOT_DELAY_MIN_INITIAL-FRAY_ARMS_SHOT_DELAY_MIN_LEVEL_FACTOR*game.currentLevelNumber);
      baddie.shotDelayMax = MAX(FRAY_ARMS_SHOT_DELAY_MAX_MIN,FRAY_ARMS_SHOT_DELAY_MAX_INITIAL-FRAY_ARMS_SHOT_DELAY_MAX_LEVEL_FACTOR*game.currentLevelNumber);
      if (numArms == 2)
        baddie.seekingOffset = -1*FRAY_ARMS_PAIR_OFFSET + 2*i*FRAY_ARMS_PAIR_OFFSET;
      baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],[TERandom randomFractionFrom:game.bottom+FRAY_ARMS_SEEKING_BOTTOM_OFFSET to:game.top-FRAY_ARMS_SEEKING_TOP_OFFSET]);
      baddie.hitPoints = FRAY_ARMS_INITIAL_HITPOINTS + (game.currentLevelNumber-1)/FRAY_ARMS_LEVELS_PER_HITPOINT;
      baddie.numShots = FRAY_ARMS_INITIAL_NUM_SHOTS + (game.currentLevelNumber-1)/FRAY_ARMS_LEVELS_PER_SHOT;
      [baddie setupInGame:game];
    }
    
    // Setup seekers
    for (int i = 0; i < numSeekers; i++) {
      Seeker *baddie = [[Seeker alloc] init];
      baddie.shotDelayConstant  = MAX(FRAY_SEEKER_SHOT_DELAY_CONSTANT_MIN,FRAY_SEEKER_SHOT_DELAY_CONSTANT_INITIAL-FRAY_SEEKER_SHOT_DELAY_CONSTANT_LEVEL_FACTOR*game.currentLevelNumber);
      baddie.distanceToShoot    = MAX(FRAY_SEEKER_SHOT_DISTANCE_MIN,      FRAY_SEEKER_SHOT_DISTANCE_INITIAL      -FRAY_SEEKER_SHOT_DISTANCE_LEVEL_FACTOR      *game.currentLevelNumber);
      baddie.maxVelocity        = MIN(FRAY_SEEKER_MAX_VELOCITY_MAX,       FRAY_SEEKER_MAX_VELOCITY_INITIAL       +FRAY_SEEKER_MAX_VELOCITY_LEVEL_FACTOR       *game.currentLevelNumber);
      baddie.accelerationFactor = MIN(FRAY_SEEKER_MAX_ACCEL_FACTOR_MAX,   FRAY_SEEKER_MAX_ACCEL_FACTOR_INITIAL   +FRAY_SEEKER_MAX_ACCEL_FACTOR_LEVEL_FACTOR   *game.currentLevelNumber);
      
      float y = numSeekers == 1 ? FRAY_SEEKER_MIDDLE_BOTTOM_OFFSET : (i == 0 ? FRAY_SEEKER_BOTTOM_BOTTOM_OFFSET : FRAY_SEEKER_TOP_BOTTOM_OFFSET);
      if (i == 1) {
        baddie.accelerationFactor += FRAY_SEEKER_TOP_ACCEL_FACTOR_BONUS;
        baddie.maxVelocity += FRAY_SEEKER_TOP_MAX_VELOCITY_BONUS;
      }
      baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],y+[TERandom randomFractionFrom:(-1*FRAY_SEEKER_Y_VARIANCE) to:FRAY_SEEKER_Y_VARIANCE]);
      baddie.hitPoints = FRAY_SEEKER_INITIAL_HITPOINTS + (game.currentLevelNumber-1)/FRAY_SEEKER_LEVELS_PER_HITPOINT;
      [baddie setupInGame:game];
    }
    
    // Setup spinners
    for (int i = 0; i < numSpinners; i++) {
      Spinner *baddie = [[Spinner alloc] init];
      baddie.shotDelayConstant  = MAX(FRAY_SPINNER_SHOT_DELAY_CONSTANT_MIN,FRAY_SPINNER_SHOT_DELAY_CONSTANT_INITIAL-FRAY_SPINNER_SHOT_DELAY_CONSTANT_LEVEL_FACTOR*game.currentLevelNumber);
      baddie.maxVelocity        = MIN(FRAY_SPINNER_MAX_VELOCITY_MAX,       FRAY_SPINNER_MAX_VELOCITY_INITIAL       +FRAY_SPINNER_MAX_VELOCITY_LEVEL_FACTOR       *game.currentLevelNumber);
      baddie.accelerationFactor = MIN(FRAY_SPINNER_MAX_ACCEL_FACTOR_MAX,   FRAY_SPINNER_MAX_ACCEL_FACTOR_INITIAL   +FRAY_SPINNER_MAX_ACCEL_FACTOR_LEVEL_FACTOR   *game.currentLevelNumber);
      
      float y = numSpinners == 1 ? FRAY_SPINNER_MIDDLE_BOTTOM_OFFSET : (i == 0 ? FRAY_SPINNER_BOTTOM_BOTTOM_OFFSET : FRAY_SPINNER_TOP_BOTTOM_OFFSET);
      if (i == 1) {
        baddie.accelerationFactor += FRAY_SPINNER_TOP_ACCEL_FACTOR_BONUS;
        baddie.maxVelocity += FRAY_SPINNER_TOP_MAX_VELOCITY_BONUS;
      }
      baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],y+[TERandom randomFractionFrom:(-1*FRAY_SPINNER_Y_VARIANCE) to:FRAY_SPINNER_Y_VARIANCE]);
      baddie.hitPoints = FRAY_SPINNER_INITIAL_HITPOINTS + (game.currentLevelNumber-1)/FRAY_SPINNER_LEVELS_PER_HITPOINT;
      [baddie setupInGame:game];
    }    
    
    recurseEnemiesForCollisions = YES;
  }
  return self;
}

-(void)update:(NSTimeInterval)dt {
  [ClassicHorde updateRowsAndColumnsForLevel:self inGame:game];
}

@end
