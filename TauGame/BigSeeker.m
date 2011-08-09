//
//  BigSeeker.m
//  TauGame
//
//  Created by Ian Terrell on 8/9/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "BigSeeker.h"

@implementation BigSeeker

- (id)init
{
  self = [super init];
  if (self) {
    self.scale = 2;
  }
  
  return self;
}

-(float)bulletVelocity {
  return 1.5*[super bulletVelocity];
}

-(void)shootInScene:(Game *)scene {
  if ([self dead])
    return;
  
  [[TESoundManager sharedManager] play:@"shoot"];
  [self shootInDirection:GLKVector2Make(0, -1) inScene:scene xOffset:0];
  [self shootInDirection:GLKVector2Make(0.25, -1) inScene:scene xOffset:0.25];
  [self shootInDirection:GLKVector2Make(-0.25, -1) inScene:scene xOffset:-0.25];    
  
  [self resetShotDelay];
}


@end
