//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"
#import "Bullet.h"

@implementation AsteroidField

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    [self setLeft:0 right:8 bottom:0 top:12];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    
    // Set up motion
    attitude = [[TEAdjustedAttitude alloc] init];
    
    // Set up fighter
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make(6, 0.1);
    fighter.maxVelocity = 20;
    fighter.maxAcceleration = 40;
    [characters addObject:fighter];
    
    [attitude zero];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *zeroRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zero)];
    zeroRecognizer.numberOfTouchesRequired = 3;
    [self addGestureRecognizer:zeroRecognizer];
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
//  CMAttitude *attitude = [TauEngine motionManager].deviceMotion.attitude;
//  [attitude multiplyByInverseOfAttitude:zeroedAttitude];
//  NSLog(@"Roll %f, pitch %f, yaw %f", attitude.adjustedRoll, attitude.adjustedPitch, attitude.adjustedYaw);'
  
//  float horizontalAccel = [TEAccelerometer horizontal];
//  NSLog(@"accel is %f", horizontalAccel);
//  fighter.acceleration = GLKVector2Make(100*horizontalAccel, 0);
    
  [attitude update];
  fighter.velocity = GLKVector2Make(30*attitude.roll, 0);
  
  [super glkViewControllerUpdate:controller];
  
  if (fighter.position.x > self.topRightVisible.x)
    fighter.position = GLKVector2Make(self.bottomLeftVisible.x, fighter.position.y);
  else if (fighter.position.x < self.bottomLeftVisible.x)
    fighter.position = GLKVector2Make(self.topRightVisible.x, fighter.position.y);
  
  [characters filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id character, NSDictionary *bindings){
    if ([character isKindOfClass:[Bullet class]]) {
      return ((Bullet *)character).position.y < (self.topRightVisible.y + 1);
    } else {
      return YES;
    }
  }]];
}

-(void)zero {
  [attitude zero];
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
