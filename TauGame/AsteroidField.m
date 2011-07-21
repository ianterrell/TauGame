//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"

@implementation AsteroidField

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    [self setLeft:0 right:8 bottom:0 top:12];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    
    // Set up fighter
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make(6, 0.1);
    fighter.maxVelocity = 20;
    fighter.maxAcceleration = 40;
    [characters addObject:fighter];
    
    // Set up a baddie
    Baddie *baddie = [[Baddie alloc] init];
    baddie.position = GLKVector2Make(6, 8);
    [characters addObject:baddie];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self addGestureRecognizer:tapRecognizer];
  }
  
  return self;
}

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation {
  return orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight;
}

-(void)orientationChangedTo:(UIDeviceOrientation)orientation {
  [super orientationChangedTo:orientation];
  fighter.position = GLKVector2Make(fighter.position.x, self.bottomLeftVisible.y + 0.1);
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  // Detect collisions
  NSArray *collisions = [TECollisionDetector collisionsIn:characters maxPerNode:1];
  for (NSArray *pair in collisions) {
    NSLog(@"Removing pair!");
    // Only bullets can collide currently
    ((TENode *)[pair objectAtIndex:0]).remove = YES;
    ((TENode *)[pair objectAtIndex:1]).remove = YES;
  }
}

-(void)tappedOnce:(UIGestureRecognizer *)gestureRecognizer {
  NSLog(@"tapped at (%f,%f)", [gestureRecognizer locationInView:self].x, [gestureRecognizer locationInView:self].y);
  NSLog(@"%d characters on screen", [characters count]);
  
  // Shoot
  TECharacter *bullet = [[Bullet alloc] init];
  bullet.position = GLKVector2Make(fighter.position.x, fighter.position.y + 1.01);
  bullet.velocity = GLKVector2Make(0, 5);
  [characters addObject:bullet];
}

@end
