//
//  TEAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@implementation TEAnimation

@synthesize type, elapsedTime, duration, value0, value1, repeat, easing, remove;

- (id)init
{
  self = [super init];
  if (self) {
    easing = TEAnimationEasingLinear;
    elapsedTime = 0.0;
  }
  
  return self;
}

+(float)modifiedScaleValue:(float)finalValue {
  if (finalValue > 1.0)
    return finalValue - 1.0;
  else
    return 1.0 - finalValue;
}

-(float)easedValueFor:(float)finalValue atPercent:(float)percentDone {
  float easedValue;
  
  if (type == TEAnimationScale)
    finalValue = [TEAnimation modifiedScaleValue:value0];
  
  switch (easing) {
    case TEAnimationEasingLinear:
      easedValue = percentDone * finalValue;
      break;
    default:
      break;
  }
  
  if (type == TEAnimationScale)
    easedValue += 1.0;
  
  return easedValue;
}

-(GLKMatrix4)modelViewMatrix {
  GLKMatrix4 mvMatrix;
  
  double percentDone = elapsedTime/duration; 
  if (percentDone > 1.0)
    percentDone = 1.0;
  
  GLfloat easedValue0 = [self easedValueFor:value0 atPercent:percentDone];
  GLfloat easedValue1 = [self easedValueFor:value1 atPercent:percentDone];
  
  switch (type) {
    case TEAnimationScale:
      mvMatrix = GLKMatrix4MakeScale(easedValue0, easedValue0, easedValue0);
      break;
    case TEAnimationRotate:
      mvMatrix = GLKMatrix4MakeZRotation(easedValue0);
      break;
    case TEAnimationTranslate:
      mvMatrix = GLKMatrix4MakeTranslation(easedValue0, easedValue1, 0.0);
    default:
      break;
  }
  
  return mvMatrix;
}

-(void)incrementElapsedTime:(double)time {
  elapsedTime += time;
  if (elapsedTime >= duration) {
    if (repeat > 0 || repeat == TEAnimationRepeatForever) {
      elapsedTime -= duration;
      if (repeat > 0)
        repeat -= 1;
    } else {
      remove = YES;
    }
  }
}

@end
