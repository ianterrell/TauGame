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

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    frames = 0;
    asteroidInterval = 120/game.currentLevelNumber;
  }
  return self;
}

-(void)update {
  frames++;
  
  if (frames % asteroidInterval == 0 && frames < 10*60)
    [self addAsteroid];
}

-(BOOL)done {
  return frames >= 10*60 && [game.enemies count] == 0;
}

-(void)addAsteroid {
  Asteroid *asteroid = [[Asteroid alloc] init];
  asteroid.position = GLKVector2Make([TERandom randomFractionFrom:game.bottomLeftVisible.x to:game.topRightVisible.x], game.topRightVisible.y);
  [game.characters insertObject:asteroid atIndex:2];
  [game.enemies addObject:asteroid];
  [game.enemyBullets addObject:asteroid];
}

@end

