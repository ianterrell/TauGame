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
#import "ExtraLife.h"
#import "ExtraShot.h"
#import "BulletSplash.h"

#define POWERUP_CHANCE 0.1
#define NUM_POWERUPS 3

static Class powerupClasses[NUM_POWERUPS];

@implementation AsteroidField

@synthesize asteroids;

+(void)initialize {
  int i = 0;
  powerupClasses[i++] = [ExtraBullet class];
  powerupClasses[i++] = [ExtraLife class];
  powerupClasses[i++] = [ExtraShot class];
}

- (id)init
{
  self = [super init];
  if (self) {
    asteroids = [[NSMutableArray alloc] initWithCapacity:20];
    
    // Set up notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(asteroidDestroyed:) name:AsteroidDestroyedNotification object:nil];
  }
  
  return self;
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  if ([controller framesDisplayed] % (0 + [TERandom rollDiceWithSides:300]) == 0) {
    [self newAsteroid];
  }
  
  // Detect collisions with bullets :)
  [TECollisionDetector collisionsBetween:bullets andNodes:asteroids maxPerNode:1 withBlock:^(TENode *bullet, TENode *asteroid) {
    bullet.remove = YES;
    [self.characters addObject:[[BulletSplash alloc] initWithPosition:bullet.position]];
    
    [(Asteroid *)asteroid registerHit];
    [self incrementScore:1];
  }];
  
  // Detect collisions with ship :(
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:asteroids maxPerNode:1 withBlock:^(TENode *ship, TENode *asteroid) {
    [(Fighter *)fighter registerHit];
    [(Asteroid *)asteroid explode];
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
  [characters insertObject:asteroid atIndex:1];
  [asteroids addObject:asteroid];
}

-(void)asteroidDestroyed:(NSNotification *)notification {
  Asteroid *asteroid = notification.object;

  [self incrementScoreWithPulse:10];
  
  if ([TERandom randomFraction] < POWERUP_CHANCE) {
    [powerupClasses[[TERandom randomTo:NUM_POWERUPS]] addPowerupToScene:self at:asteroid.position];
  }
    
}

-(void)nodeRemoved:(TENode *)node {
  [super nodeRemoved:node];
  if ([node isKindOfClass:[Asteroid class]])
    [asteroids removeObject:node];
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AsteroidDestroyedNotification object:nil];
}

@end

