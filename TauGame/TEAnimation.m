//
//  TEAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@implementation TEAnimation

@synthesize type, elapsedTime, duration, value0, value1, repeat, easing;

- (id)init
{
  self = [super init];
  if (self) {
    easing = TEAnimationEasingLinear;
    elapsedTime = 0.0;
  }
  
  return self;
}

-(GLKMatrix4)modelViewMatrix {
  GLKMatrix4 mvMatrix;
  
  GLfloat easedValue0, easedValue1;
  double percentDone = elapsedTime*10000/duration; // FIXME: time sent should be in seconds, this is bizarre
  
  switch (easing) {
    case TEAnimationEasingLinear:
      easedValue0 = percentDone * value0;
      easedValue1 = percentDone * value1;
      break;
    default:
      break;
  }
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

@end
