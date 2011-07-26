//
//  AsteroidField.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "FighterScene.h"
#import "Asteroid.h"

@interface AsteroidField : FighterScene {
  NSMutableArray *asteroids;
}

@property(strong) NSMutableArray *asteroids;

-(void)newAsteroid;

@end
