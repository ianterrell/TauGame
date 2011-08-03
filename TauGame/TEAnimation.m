//
//  TEAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@implementation TEAnimation

@synthesize node, next, elapsedTime, duration, repeat, easing, remove, reverse, onRemoval;

- (id)init
{
  self = [super init];
  if (self) {
    easing = kTEAnimationEasingLinear;
    forward = YES;
    reverse = NO;
    elapsedTime = 0.0;
  }
  
  return self;
}

-(id)initWithNode:(TENode *)_node
{
  self = [self init];
  if (self) {
    self.node = _node;
  }
  
  return self;
}

-(float)percentDone {
  return forward ? elapsedTime/duration : 1.0 - elapsedTime/duration;
}

-(float)easingFactor {
  switch (easing) {
    case kTEAnimationEasingLinear:
      return self.percentDone;
    default:
      return 0.0;
  }
}

-(void)incrementElapsedTime:(double)time {
  elapsedTime += time;
  if (elapsedTime >= duration) {
    if (forward && reverse) {
      elapsedTime -= duration;
      forward = !forward;
    } else if (repeat > 0 || repeat == kTEAnimationRepeatForever) {
      forward = !forward;
      elapsedTime -= duration;
      if (repeat > 0)
        repeat -= 1;
    } else {
      remove = YES;
    }
  }
}

-(BOOL)backward {
  return !forward;
}

-(void)setBackward:(BOOL)backward {
  forward = !backward;
}

@end
