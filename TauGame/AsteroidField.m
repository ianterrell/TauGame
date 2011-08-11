//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"
#import "Asteroid.h"

@implementation AsteroidField

+(NSString *)name {
  return @"Asteroid Field";
}

-(void)setTimeUntilNextAsteroid {
  timeUntilNextAsteroid = averageInterval + [TERandom randomFractionFrom:-0.5*averageInterval to:0.5*averageInterval];
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    elapsedTime = 0;
    numAsteroids = MIN(ASTEROIDS_NUM_MAX,ASTEROIDS_NUM_INITIAL + game.currentLevelNumber * ASTEROIDS_NUM_LEVEL_FACTOR);
    averageInterval = ASTEROIDS_TIME / numAsteroids;
    [self setTimeUntilNextAsteroid];
    game.levelLoading = NO;
  }
  return self;
}

-(void)update:(NSTimeInterval)dt {
  elapsedTime += dt;
  
  if (timeUntilNextAsteroid > 0)
    timeUntilNextAsteroid -= dt;
  else if (numAsteroids > 0)
    [self addAsteroid];
}

-(BOOL)done {
  return elapsedTime >= ASTEROIDS_TIME && [game.enemies count] == 0 && numAsteroids <= 0;
}

-(void)addAsteroid {
  Asteroid *asteroid = [[Asteroid alloc] init];
  asteroid.position = GLKVector2Make([TERandom randomFractionFrom:game.bottomLeftVisible.x to:game.topRightVisible.x], game.topRightVisible.y);

  float scaleBottom = MIN(ASTEROIDS_SIZE_MIN_MAX,ASTEROIDS_SIZE_MIN_INITIAL + game.currentLevelNumber * ASTEROIDS_SIZE_MIN_LEVEL_FACTOR);
  float scaleTop = MIN(ASTEROIDS_SIZE_MAX_MAX,ASTEROIDS_SIZE_MAX_INITIAL + game.currentLevelNumber * ASTEROIDS_SIZE_MAX_LEVEL_FACTOR);  
  asteroid.scale = [TERandom randomFractionFrom:scaleBottom to:scaleTop];
  
  asteroid.hitPoints = asteroid.scale * MIN(ASTEROIDS_HP_PER_SCALE_MAX,ASTEROIDS_HP_PER_SCALE_INITIAL + game.currentLevelNumber * ASTEROIDS_HP_PER_SCALE_LEVEL_FACTOR);  
  
  [asteroid setupInGame:game];
  numAsteroids--;
  [self setTimeUntilNextAsteroid];
}

@end

