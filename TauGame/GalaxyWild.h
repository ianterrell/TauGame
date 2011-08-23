//
//  GalaxyWild.h
//  TauGame
//
//  Created by Ian Terrell on 8/9/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

/**
 * Debug settings
 */

//#define DEBUG_LEVEL  [ClassicHorde class]
//#define DEBUG_BIGGUN [BigHordeUnit class]
//#define DEBUG_SKIP_LEVELS 3
//#define DEBUG_KEEP_POWERUPS
//#define DEBUG_FIGHTER_POWERFUL
//#define DEBUG_INVINCIBLE
//#define DEBUG_INITIAL_SCENE @"credits"

/**
 * Major settings
 */

#define POINT_RATIO 40

#define HIGH_SCORE_CATEGORY @"highscore"
#define HIGH_LEVEL_CATEGORY @"highlevel"

#define UPGRADE_PRODUCT_ID @"upgrade"
#define UPGRADED_PREFERENCES_KEY @"did-upgrade-app"

#define CAN_USE_GK_PREFERENCES_KEY @"can-use-gk"

/**
 * Levels
 */

#define NUM_GAME_LEVELS 4

/**
 * Multiplier
 */

#define MULTIPLIER_PER_HIT  1
#define MULTIPLIER_PER_KILL 3
#define MAX_MULTIPLIER      999
#define MIN_MULTIPLIER      10

#define MULTIPLIER_DECAY_INTERVAL 3
#define MULTIPLIER_DECAY_AMOUNT   1

/**
 * Powerups
 */

#define POWERUP_SHOT_CHANCE   0.01
#define POWERUP_BULLET_CHANCE 0.01
#define POWERUP_LIFE_CHANCE   0.02
#define POWERUP_HEALTH_CHANCE 0.06
#define POWERUP_SCORE_CHANCE  0.25

#define WEAPON_POWERUP_PER_N_LEVELS (NUM_GAME_LEVELS/2)

#define POWERUP_WEAPON_SCORE 50
#define POWERUP_LIFE_SCORE   50
#define POWERUP_HEALTH_SCORE 30
#define POWERUP_SCORE_SCORE  20

/**
 * Fighter Config
 */

#define FIGHTER_INITIAL_LIVES  1
#define FIGHTER_UPGRADE_LIVES  2
#define FIGHTER_INITIAL_HEALTH 3
#define FIGHTER_MAX_HEALTH     3

#define FIGHTER_INITIAL_SHOT_SPEED 1.0

//#define FIGHTER_SPREAD_ENABLED
#define FIGHTER_BULLET_X_SPREAD_FACTOR 3.2
#define FIGHTER_BULLET_Y_SPREAD_FACTOR 3.0
#define FIGHTER_BULLET_Y_VELOCITY 6.0
#define FIGHTER_BULLET_X_VELOCITY_FACTOR 0.75

#ifdef DEBUG_FIGHTER_POWERFUL
#define FIGHTER_INITIAL_NUM_BULLETS 3
#define FIGHTER_INITIAL_NUM_SHOTS 10
#define FIGHTER_MAX_BULLETS 3
#define FIGHTER_MAX_SHOTS 10
#else
#define FIGHTER_INITIAL_NUM_BULLETS 1
#define FIGHTER_INITIAL_NUM_SHOTS 1
#define FIGHTER_MAX_BULLETS 3
#define FIGHTER_MAX_SHOTS 3
#endif

#define FIGHTER_MAX_VELOCITY 10
#define FIGHTER_ACCELEROMETER_SENSITIVITY 35
#define FIGHTER_TURN_FACTOR 5
#define FIGHTER_MAX_TURN (1.0/6)

/**
 * Asteroid Field
 */

#define ASTEROIDS_TIME                      10.0

#define ASTEROIDS_NUM_INITIAL               20
#define ASTEROIDS_NUM_MAX                   60
#define ASTEROIDS_NUM_LEVEL_FACTOR          2

#define ASTEROIDS_SIZE_MIN_MAX              0.6
#define ASTEROIDS_SIZE_MIN_INITIAL          0.25
#define ASTEROIDS_SIZE_MIN_LEVEL_FACTOR     0.01

#define ASTEROIDS_SIZE_MAX_MAX              1.5
#define ASTEROIDS_SIZE_MAX_INITIAL          0.75
#define ASTEROIDS_SIZE_MAX_LEVEL_FACTOR     0.02

#define ASTEROIDS_HP_PER_SCALE_MAX          10
#define ASTEROIDS_HP_PER_SCALE_INITIAL      4
#define ASTEROIDS_HP_PER_SCALE_LEVEL_FACTOR 0.1


/**
 * Classic Horde Mode (and horde in Fray)
 */

#define HORDE_LEVELS_PER_HITPOINT 20

#define HORDE_MAX_ROWS 6
#define HORDE_INITIAL_ROWS 1
#define HORDE_LEVELS_PER_ROW NUM_GAME_LEVELS

#define HORDE_MAX_COLS 8
#define HORDE_INITIAL_COLS 2
#define HORDE_LEVELS_PER_COL NUM_GAME_LEVELS

#define HORDE_SHOT_DELAY_MIN_MIN 0.5
#define HORDE_SHOT_DELAY_MIN_INITIAL 1.5
#define HORDE_SHOT_DELAY_MIN_LEVEL_FACTOR 0.1
#define HORDE_SHOT_DELAY_MAX_MIN 1.5
#define HORDE_SHOT_DELAY_MAX_INITIAL 5.5
#define HORDE_SHOT_DELAY_MAX_LEVEL_FACTOR 0.1

#define HORDE_MAX_VELOCITY_MAX 5
#define HORDE_MAX_VELOCITY_FACTOR 3
#define HORDE_X_VELOCITY_INITIAL 0.5
#define HORDE_X_VELOCITY_LEVEL_FACTOR 0.1
#define HORDE_X_ACCEL_LEVEL_FACTOR 0.005
#define HORDE_Y_VELOCITY_INITIAL 0.01
#define HORDE_Y_VELOCITY_LEVEL_FACTOR 0.01
#define HORDE_Y_ACCEL_LEVEL_FACTOR 0.0025

/**
 * Fray (and most of Dogfight)
 */

// Arms

#define FRAY_ARMS_SHOT_DELAY_MIN_MIN 2
#define FRAY_ARMS_SHOT_DELAY_MIN_INITIAL 3
#define FRAY_ARMS_SHOT_DELAY_MIN_LEVEL_FACTOR 0.05
#define FRAY_ARMS_SHOT_DELAY_MAX_MIN 4
#define FRAY_ARMS_SHOT_DELAY_MAX_INITIAL 5
#define FRAY_ARMS_SHOT_DELAY_MAX_LEVEL_FACTOR 0.05

#define FRAY_ARMS_PAIR_OFFSET 0.33

#define FRAY_ARMS_SEEKING_TIME_MIN 2
#define FRAY_ARMS_SEEKING_TIME_MAX 4

#define FRAY_ARMS_SEEKING_BOTTOM_OFFSET 3
#define FRAY_ARMS_SEEKING_TOP_OFFSET 1

#define FRAY_ARMS_INITIAL_HITPOINTS 2
#define FRAY_ARMS_LEVELS_PER_HITPOINT NUM_GAME_LEVELS

#define FRAY_ARMS_INITIAL_NUM_SHOTS 2
#define FRAY_ARMS_LEVELS_PER_SHOT 20

// Seeker

#define FRAY_SEEKER_SHOT_DELAY_CONSTANT_MIN 1
#define FRAY_SEEKER_SHOT_DELAY_CONSTANT_INITIAL 2
#define FRAY_SEEKER_SHOT_DELAY_CONSTANT_LEVEL_FACTOR 0.05

#define FRAY_SEEKER_SHOT_DISTANCE_MIN 0.5
#define FRAY_SEEKER_SHOT_DISTANCE_INITIAL 1
#define FRAY_SEEKER_SHOT_DISTANCE_LEVEL_FACTOR 0.05

#define FRAY_SEEKER_MAX_VELOCITY_MAX 3
#define FRAY_SEEKER_MAX_VELOCITY_INITIAL 2
#define FRAY_SEEKER_MAX_VELOCITY_LEVEL_FACTOR 0.05
#define FRAY_SEEKER_TOP_MAX_VELOCITY_BONUS 1

#define FRAY_SEEKER_MAX_ACCEL_FACTOR_MAX 3
#define FRAY_SEEKER_MAX_ACCEL_FACTOR_INITIAL 1
#define FRAY_SEEKER_MAX_ACCEL_FACTOR_LEVEL_FACTOR 0.1
#define FRAY_SEEKER_TOP_ACCEL_FACTOR_BONUS 1

#define FRAY_SEEKER_BOTTOM_BOTTOM_OFFSET 4
#define FRAY_SEEKER_MIDDLE_BOTTOM_OFFSET 5
#define FRAY_SEEKER_TOP_BOTTOM_OFFSET    6
#define FRAY_SEEKER_Y_VARIANCE           0.5

#define FRAY_SEEKER_INITIAL_HITPOINTS 2
#define FRAY_SEEKER_LEVELS_PER_HITPOINT NUM_GAME_LEVELS

// Spinner

#define FRAY_SPINNER_SHOT_DELAY_CONSTANT_MIN 3
#define FRAY_SPINNER_SHOT_DELAY_CONSTANT_INITIAL 5
#define FRAY_SPINNER_SHOT_DELAY_CONSTANT_LEVEL_FACTOR 0.05

#define FRAY_SPINNER_MAX_VELOCITY_MAX 3
#define FRAY_SPINNER_MAX_VELOCITY_INITIAL 2
#define FRAY_SPINNER_MAX_VELOCITY_LEVEL_FACTOR 0.05
#define FRAY_SPINNER_TOP_MAX_VELOCITY_BONUS 1

#define FRAY_SPINNER_MAX_ACCEL_FACTOR_MAX 3
#define FRAY_SPINNER_MAX_ACCEL_FACTOR_INITIAL 1
#define FRAY_SPINNER_MAX_ACCEL_FACTOR_LEVEL_FACTOR 0.1
#define FRAY_SPINNER_TOP_ACCEL_FACTOR_BONUS 1

#define FRAY_SPINNER_BOTTOM_BOTTOM_OFFSET 4
#define FRAY_SPINNER_MIDDLE_BOTTOM_OFFSET 5
#define FRAY_SPINNER_TOP_BOTTOM_OFFSET    6
#define FRAY_SPINNER_Y_VARIANCE           0.5

#define FRAY_SPINNER_INITIAL_HITPOINTS 2
#define FRAY_SPINNER_LEVELS_PER_HITPOINT NUM_GAME_LEVELS

/**
 * Dogfight
 */

#define DOGFIGHT_BOTTOM_OFFSET 3
#define DOGFIGHT_TOP_OFFSET 1

#define DOGFIGHT_INITIAL_HITPOINTS 4
#define DOGFIGHT_LEVELS_PER_HITPOINT 1

/**
 * Helpers
 */

#define Round(gameLevel) (1+(gameLevel-1)/NUM_GAME_LEVELS)