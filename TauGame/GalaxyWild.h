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
//#define DEBUG_BIGGUN [BigSpinner class]


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

#define SCORE_BONUS_CHANCE 0.75
#define SCORE_BONUS_AMOUNT 100

/**
 * Fighter Config
 */

#define FIGHTER_INITIAL_LIVES  3
#define FIGHTER_INITIAL_HEALTH 3
#define FIGHTER_MAX_HEALTH     3

#define FIGHTER_BULLET_X_SPREAD_FACTOR 3.2
#define FIGHTER_BULLET_Y_SPREAD_FACTOR 3.0
#define FIGHTER_BULLET_Y_VELOCITY 6.0
#define FIGHTER_BULLET_X_VELOCITY_FACTOR 0.75

#define FIGHTER_MAX_BULLETS 3
#define FIGHTER_MAX_SHOTS 3

#define FIGHTER_MAX_VELOCITY 10
#define FIGHTER_ACCELEROMETER_SENSITIVITY 35
#define FIGHTER_TURN_FACTOR 5