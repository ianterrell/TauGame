//
//  TEScaleAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScaleAnimation.h"

@implementation TEScaleAnimation

@synthesize scale;

- (id)init
{
  self = [super init];
  if (self) {
    scale = 1.0;
  }
  
  return self;
}

-(float)easedScale {
  return 1.0 + self.easingFactor * (scale - 1.0);
}

@end
