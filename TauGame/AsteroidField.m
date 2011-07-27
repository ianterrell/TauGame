//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"
#import "Fighter.h"

@implementation AsteroidField

@synthesize asteroids;

- (id)init
{
  self = [super init];
  if (self) {
    asteroids = [[NSMutableArray alloc] initWithCapacity:20];
  }
  
  return self;
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  if ([controller framesDisplayed] % (0 + [TERandom rollDiceWithSides:300]) == 0) {
    [self newAsteroid];
  }
  
  // Detect collisions with bullets :)
  [TECollisionDetector collisionsBetween:bullets andNodes:asteroids recurseLeft:NO recurseRight:YES maxPerNode:1 withBlock:^(TENode *bullet, TENode *asteroid) {
    bullet.remove = YES;
    [(Asteroid *)asteroid registerHit];
  }];
  
  // Detect collisions with ship :(
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:asteroids recurseLeft:NO recurseRight:YES maxPerNode:1 withBlock:^(TENode *ship, TENode *asteroid) {
    [(Fighter *)fighter registerHit];
    [(Asteroid *)asteroid die];
  }];
}

-(void)newAsteroid {
  Asteroid *asteroid = [[Asteroid alloc] init];
  asteroid.position = GLKVector2Make([TERandom randomFractionFrom:self.bottomLeftVisible.x to:self.topRightVisible.x], self.topRightVisible.y);
  [characters addObject:asteroid];
  [asteroids addObject:asteroid];
}


@end

