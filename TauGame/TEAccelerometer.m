//
//  TEAccelerometer.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAccelerometer.h"

static double previousXAccel = 0.0;
static double previousYAccel = 0.0;
static double kFilterFactor = 0.05;

@implementation TEAccelerometer

+(float)horizontal {
  CMAcceleration userAccel = [TauEngine motionManager].deviceMotion.userAcceleration;
  
  double xAccel = userAccel.x*kFilterFactor+(1-kFilterFactor)*previousXAccel;
  double yAccel = userAccel.y*kFilterFactor+(1-kFilterFactor)*previousYAccel;
  
  previousXAccel = xAccel;
  previousYAccel = yAccel;
  
  switch ([TESceneController sharedController].currentScene.currentOrientation) {
    case UIDeviceOrientationPortrait:
      return xAccel;
    case UIDeviceOrientationPortraitUpsideDown:
      return -1.0*xAccel;
    case UIDeviceOrientationLandscapeLeft:
      return -1.0*yAccel;
    case UIDeviceOrientationLandscapeRight:
      return yAccel;
    default:
      return xAccel;
  }
}

@end
