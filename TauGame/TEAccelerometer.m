//
//  TEAccelerometer.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAccelerometer.h"

static double previousHorizontal = 0.0;
static double kFilterFactor = 0.05;
static CMAcceleration calibration;

@implementation TEAccelerometer;

+(void)zero {
  calibration = [TauEngine motionManager].accelerometerData.acceleration;
}

+(float)horizontal {
  CMAcceleration accel = [TauEngine motionManager].accelerometerData.acceleration;
  float horizontal;
  
  switch ([TESceneController sharedController].currentScene.currentOrientation) {
    case UIDeviceOrientationPortrait:
      horizontal = (accel.x - calibration.x);
      break;
    case UIDeviceOrientationPortraitUpsideDown:
      horizontal = -1*(accel.x - calibration.x);
      break;
    case UIDeviceOrientationLandscapeLeft:
      horizontal = -1*(accel.y - calibration.y);
      break;
    case UIDeviceOrientationLandscapeRight:
      horizontal = (accel.y - calibration.y);
      break;
    default:
      horizontal = (accel.x - calibration.x);
  }
  
  horizontal = horizontal*kFilterFactor+(1-kFilterFactor)*previousHorizontal;
  previousHorizontal = horizontal;
  return horizontal;
}

@end
