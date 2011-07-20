//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"

// If we were in portrait mode
static float width = 20.0;
static float height = 30.0;

@implementation AsteroidField

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    [self setupCoordinateSystem];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    
    // Set up fighters
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make(width/2, 1);
    [characters addObject:fighter];
  }
  
  return self;
}

-(void)setupCoordinateSystem {
//  if (UIDeviceOrientationIsPortrait(currentOrientation)) {
//    width = 20;
//    height = 30;
//  } else {
//    width = 30;
//    height = 20;
//  }
    NSLog(@"width now %f and height now %f", width, height);
  [self setLeft:-width/2.0 right:width/2.0 bottom:-height/2.0 top:height/2.0];
}

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation {
  return orientation != UIDeviceOrientationFaceDown && orientation != UIDeviceOrientationFaceUp;
}

-(void)orientationChangedTo:(UIDeviceOrientation)orientation {
  [super orientationChangedTo:orientation];
  [self setupCoordinateSystem];
  fighter.position = GLKVector2Make(5, 5);
}

@end
