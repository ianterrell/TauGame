//
//  AsteroidField.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameLevel.h"

@interface AsteroidField : GameLevel {
  int frames, asteroidInterval;
}

-(void)addAsteroid;

@end
