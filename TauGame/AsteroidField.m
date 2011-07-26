//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"

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
  
  if ([controller framesDisplayed] % [TERandom rollDiceWithSides:300] == 0) {
    [self newAsteroid];
  }
  
  // Detect collisions
  [TECollisionDetector collisionsBetween:bullets andNodes:asteroids recurseLeft:NO recurseRight:YES maxPerNode:1 withBlock:^(TENode *bullet, TENode *asteroid) {
    NSLog(@"hit!");
    // We've hit an asteroid!
    [sounds play:@"hurt"];
    
    // Remove the bullet
    bullet.remove = YES;
  }];
}

-(void)newAsteroid {
  Asteroid *asteroid = [[Asteroid alloc] init];
  
//  asteroid.position = GLKVector2Make(6, 4);//(self.topRightVisible.x - self.bottomLeftVisible.x)/2.0, (self.topRightVisible.y - self.bottomLeftVisible.y)/2.0);
  asteroid.scale = MAX(0.25,((float)rand()/RAND_MAX));
  asteroid.angularVelocity = [TERandom randomFraction]*M_TAU;

  asteroid.position = GLKVector2Make([TERandom randomFractionFrom:self.bottomLeftVisible.x to:self.topRightVisible.x], self.topRightVisible.y);
  asteroid.velocity = GLKVector2Make(0, [TERandom randomFractionFrom:-3.0 to:-1.0]);
  
  [characters addObject:asteroid];
  [asteroids addObject:asteroid];
}


@end

