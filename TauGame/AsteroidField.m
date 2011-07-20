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

@end
