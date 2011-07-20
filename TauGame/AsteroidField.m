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
    [self setLeft:0 right:20 bottom:0 top:30];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    
    // Set up motion
    attitude = [[TEAdjustedAttitude alloc] init];
    
    // Set up fighter
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make(0, 0);
    fighter.acceleration = GLKVector2Make(2,3);
    [characters addObject:fighter];
  }
  
  return self;
}

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation {
  return orientation != UIDeviceOrientationFaceDown && orientation != UIDeviceOrientationFaceUp;
}

-(void)orientationChangedTo:(UIDeviceOrientation)orientation {
  [super orientationChangedTo:orientation];
  fighter.position = GLKVector2Make(fighter.position.x, self.bottomLeftVisible.y + 0.5);
  [attitude zero];
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller {
//  CMAttitude *attitude = [TauEngine motionManager].deviceMotion.attitude;
//  [attitude multiplyByInverseOfAttitude:zeroedAttitude];
//  NSLog(@"Roll %f, pitch %f, yaw %f", attitude.adjustedRoll, attitude.adjustedPitch, attitude.adjustedYaw);'
  
//  float horizontalAccel = [TEAccelerometer horizontal];
//  NSLog(@"accel is %f", horizontalAccel);
//  fighter.acceleration = GLKVector2Make(100*horizontalAccel, 0);
    
  [attitude update];
  fighter.velocity = GLKVector2Make(8*attitude.roll, 0);
  
  [super glkViewControllerUpdate:controller];
  
  if (fighter.position.x > self.topRightVisible.x)
    fighter.position = GLKVector2Make(self.bottomLeftVisible.x, fighter.position.y);
  else if (fighter.position.x < self.bottomLeftVisible.x)
    fighter.position = GLKVector2Make(self.topRightVisible.x, fighter.position.y);
}

@end
