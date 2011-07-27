//
//  BaddieField.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "BaddieField.h"
#import "Asteroid.h"

@implementation BaddieField

@synthesize ships;

- (id)init
{
  self = [super init];
  if (self) {
    // Set up baddie array for collision detection
    ships = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Set up a baddie
    [self addRandomBaddie];
    [self addRandomBaddie];
    [self addRandomBaddie];
  }
  
  return self;
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  // Detect collisions
  [TECollisionDetector collisionsBetween:bullets andNodes:ships maxPerNode:1 withBlock:^(TENode *bullet, TENode *ship) {
    bullet.remove = YES;
    [(Baddie *)ship registerHit];
  }];
}

-(void)addRandomBaddie {
  Baddie *baddie = [[Baddie alloc] init];
  
  //  srand(arc4random());
  
  float randX = ((float)rand()/RAND_MAX) * self.visibleWidth + self.bottomLeftVisible.x;
  float randY = ((float)rand()/RAND_MAX) * (self.visibleHeight - 3) + self.bottomLeftVisible.y + 3;
  float randVelocity = -10.0 + (float)rand()/RAND_MAX * 20.0;
  
  baddie.position = GLKVector2Make(randX, randY);
  baddie.velocity = GLKVector2Make(randVelocity,0);
  baddie.shape.color = GLKVector4Make(((float)rand()/RAND_MAX), ((float)rand()/RAND_MAX), ((float)rand()/RAND_MAX), 1.0);
  
  if ((float)rand()/RAND_MAX > 0.8) {
    TEScaleAnimation *grow = [[TEScaleAnimation alloc] init];
    grow.scale = 1.2;
    grow.duration = 1;
    grow.repeat = TEAnimationRepeatForever;
    [baddie.currentAnimations addObject:grow];
  }
  
  if ((float)rand()/RAND_MAX > 0.8) {
    TERotateAnimation *spin = [[TERotateAnimation alloc] init];
    spin.rotation = 1*M_TAU;
    spin.duration = 1;
    spin.repeat = TEAnimationRepeatForever;
    [baddie.currentAnimations addObject:spin];
  }
  
  [self.characters addObject:baddie];
  [ships addObject:baddie];
}

@end
