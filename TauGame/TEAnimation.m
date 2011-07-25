//
//  TEAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@implementation TEAnimation

@synthesize node, elapsedTime, duration, repeat, easing, remove, onRemoval;

- (id)init
{
  self = [super init];
  if (self) {
    easing = TEAnimationEasingLinear;
    elapsedTime = 0.0;
  }
  
  return self;
}

-(id)initWithNode:(TENode *)_node
{
  self = [super init];
  if (self) {
    self.node = _node;
  }
  
  return self;
}

-(float)percentDone {
  return elapsedTime/duration;
}

-(float)easingFactor {
  switch (easing) {
    case TEAnimationEasingLinear:
      return self.percentDone;
    default:
      return 0.0;
  }
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
