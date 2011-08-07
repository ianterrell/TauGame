//
//  TEAdjustedAttitude.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAdjustedAttitude.h"

@implementation TEAdjustedAttitude

@synthesize realAttitude, adjustedAttitude, referenceAttitude;

- (id)init {
  self = [super init];
  if (self) {
    [self zero];
  }
  
  return self;
}

-(void)update {
  self.realAttitude = [TauEngine motionManager].deviceMotion.attitude;
  self.adjustedAttitude = [TauEngine motionManager].deviceMotion.attitude;
  if (self.referenceAttitude != nil)
    [self.adjustedAttitude multiplyByInverseOfAttitude:self.referenceAttitude];
}

-(void)zero {
  [self update];
  self.referenceAttitude = [self.realAttitude copy];
}

-(float)roll {
  UIInterfaceOrientation orientation = [TESceneController sharedController].interfaceOrientation;
  
  if (orientation == UIInterfaceOrientationPortrait)
    return self.adjustedAttitude.roll;
  else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    return -1.0*self.adjustedAttitude.roll;
  else if (orientation == UIInterfaceOrientationLandscapeLeft)
    return self.adjustedAttitude.yaw;
  else if (orientation == UIInterfaceOrientationLandscapeRight)
    return -1.0*self.adjustedAttitude.yaw;
  else
    return self.realAttitude.roll;
}

-(float)pitch {
  return 0.0;
}

-(float)yaw {
  return 0.0;
}

@end
