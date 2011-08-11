//
//  Dogfight.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Dogfight.h"
#import "BiggunBag.h"
#import "Baddie.h"
#import "BigHordeUnit.h"
#import "BigArms.h"
#import "BigSeeker.h"
#import "BigSpinner.h"

static BiggunBag *biggunBag;

@implementation Dogfight

+(void)initialize {
  biggunBag = [[BiggunBag alloc] init];
}

+(NSString *)name {
  return @"Dogfight";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    Baddie *baddie = [[[biggunBag drawItem] alloc] init];
    baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],[TERandom randomFractionFrom:game.bottom+DOGFIGHT_BOTTOM_OFFSET to:game.top-DOGFIGHT_TOP_OFFSET]);    
    baddie.hitPoints = DOGFIGHT_INITIAL_HITPOINTS + (game.currentLevelNumber-1)/DOGFIGHT_LEVELS_PER_HITPOINT;

    // Reuse other levels' config
    if ([baddie isKindOfClass:[BigHordeUnit class]]) {
      baddie.velocity = GLKVector2Make(HORDE_X_VELOCITY_INITIAL+HORDE_X_VELOCITY_LEVEL_FACTOR*game.currentLevelNumber,
                                       -1*(HORDE_Y_VELOCITY_INITIAL+HORDE_Y_VELOCITY_LEVEL_FACTOR*game.currentLevelNumber));
      
      baddie.maxVelocity = MIN(HORDE_MAX_VELOCITY_MAX,HORDE_MAX_VELOCITY_FACTOR*baddie.velocity.x);
      baddie.acceleration = GLKVector2Make(HORDE_X_ACCEL_LEVEL_FACTOR*game.currentLevelNumber,-1*HORDE_Y_ACCEL_LEVEL_FACTOR*game.currentLevelNumber);

      baddie.shotDelayMin = MAX(HORDE_SHOT_DELAY_MIN_MIN,HORDE_SHOT_DELAY_MIN_INITIAL-HORDE_SHOT_DELAY_MIN_LEVEL_FACTOR*game.currentLevelNumber);
      baddie.shotDelayMax = MAX(HORDE_SHOT_DELAY_MAX_MIN,HORDE_SHOT_DELAY_MAX_INITIAL-HORDE_SHOT_DELAY_MAX_LEVEL_FACTOR*game.currentLevelNumber);
    } else if ([baddie isKindOfClass:[BigArms class]]) {
      baddie.shotDelayMin         = MAX(FRAY_ARMS_SHOT_DELAY_MIN_MIN,FRAY_ARMS_SHOT_DELAY_MIN_INITIAL-FRAY_ARMS_SHOT_DELAY_MIN_LEVEL_FACTOR*game.currentLevelNumber);
      baddie.shotDelayMax         = MAX(FRAY_ARMS_SHOT_DELAY_MAX_MIN,FRAY_ARMS_SHOT_DELAY_MAX_INITIAL-FRAY_ARMS_SHOT_DELAY_MAX_LEVEL_FACTOR*game.currentLevelNumber);
      ((BigArms*)baddie).numShots = FRAY_ARMS_INITIAL_NUM_SHOTS + (game.currentLevelNumber-1)/FRAY_ARMS_LEVELS_PER_SHOT;
    } else if ([baddie isKindOfClass:[BigSeeker class]]) {
      baddie.shotDelayConstant                = MAX(FRAY_SEEKER_SHOT_DELAY_CONSTANT_MIN,FRAY_SEEKER_SHOT_DELAY_CONSTANT_INITIAL-FRAY_SEEKER_SHOT_DELAY_CONSTANT_LEVEL_FACTOR*game.currentLevelNumber);
      ((BigSeeker*)baddie).distanceToShoot    = MAX(FRAY_SEEKER_SHOT_DISTANCE_MIN,      FRAY_SEEKER_SHOT_DISTANCE_INITIAL      -FRAY_SEEKER_SHOT_DISTANCE_LEVEL_FACTOR      *game.currentLevelNumber);
      baddie.maxVelocity                      = MIN(FRAY_SEEKER_MAX_VELOCITY_MAX,       FRAY_SEEKER_MAX_VELOCITY_INITIAL       +FRAY_SEEKER_MAX_VELOCITY_LEVEL_FACTOR       *game.currentLevelNumber);
      ((BigSeeker*)baddie).accelerationFactor = MIN(FRAY_SEEKER_MAX_ACCEL_FACTOR_MAX,   FRAY_SEEKER_MAX_ACCEL_FACTOR_INITIAL   +FRAY_SEEKER_MAX_ACCEL_FACTOR_LEVEL_FACTOR   *game.currentLevelNumber);
    } else if ([baddie isKindOfClass:[BigSpinner class]]) {
      baddie.shotDelayConstant                 = MAX(FRAY_SPINNER_SHOT_DELAY_CONSTANT_MIN,FRAY_SPINNER_SHOT_DELAY_CONSTANT_INITIAL-FRAY_SPINNER_SHOT_DELAY_CONSTANT_LEVEL_FACTOR*game.currentLevelNumber);
      baddie.maxVelocity                       = MIN(FRAY_SPINNER_MAX_VELOCITY_MAX,       FRAY_SPINNER_MAX_VELOCITY_INITIAL       +FRAY_SPINNER_MAX_VELOCITY_LEVEL_FACTOR       *game.currentLevelNumber);
      ((BigSpinner*)baddie).accelerationFactor = MIN(FRAY_SPINNER_MAX_ACCEL_FACTOR_MAX,   FRAY_SPINNER_MAX_ACCEL_FACTOR_INITIAL   +FRAY_SPINNER_MAX_ACCEL_FACTOR_LEVEL_FACTOR   *game.currentLevelNumber);      
    }
    
    [baddie setupInGame:game];
    recurseEnemiesForCollisions = YES;
  }
  return self;
}

@end
