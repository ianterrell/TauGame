//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"
#import "Fighter.h"
#import "ExtraBullet.h"

#define POWERUP_CHANCE 0.1

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
    ((TENumberDisplay *)scoreboard.drawable).number += 1;
    if ([(Asteroid *)asteroid dead]) {
      ((TENumberDisplay *)scoreboard.drawable).number += 10;
      
      TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
      scaleAnimation.scale = 1.2;
      scaleAnimation.duration = 0.2;
      scaleAnimation.reverse = YES;
      [scoreboard.currentAnimations addObject:scaleAnimation];
      
      TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
      translateAnimation.translation = GLKVector2Make((((TENumberDisplay *)scoreboard.drawable).width*1.2-((TENumberDisplay *)scoreboard.drawable).width)/2, -1*(((TENumberDisplay *)scoreboard.drawable).height*1.2-((TENumberDisplay *)scoreboard.drawable).height)/2);
      translateAnimation.duration = 0.2;
      translateAnimation.reverse = YES;
      [scoreboard.currentAnimations addObject:translateAnimation];
      
      if ([TERandom randomFraction] < POWERUP_CHANCE)
        [ExtraBullet addPowerupToScene:self at:asteroid.position];
    }
  }];
  
  // Detect collisions with ship :(
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:asteroids recurseLeft:NO recurseRight:YES maxPerNode:1 withBlock:^(TENode *ship, TENode *asteroid) {
    [(Fighter *)fighter registerHit];
    [(Asteroid *)asteroid die];
  }];
  
  // Detect powerup collisions
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:powerups withBlock:^(TENode *ship, TENode *powerup) {
    [(Powerup*)powerup die];
    [fighter getPowerup:(Powerup*)powerup];
  }];
}

-(void)newAsteroid {
  Asteroid *asteroid = [[Asteroid alloc] init];
  asteroid.position = GLKVector2Make([TERandom randomFractionFrom:self.bottomLeftVisible.x to:self.topRightVisible.x], self.topRightVisible.y);
  [characters addObject:asteroid];
  [asteroids addObject:asteroid];
}


@end

