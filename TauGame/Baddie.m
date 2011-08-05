//
//  Baddie.m
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"

#define BLINK_MIN 2
#define BLINK_MAX 11

@implementation Baddie

- (id)init
{
  self = [super init];
  if (self) {
    hitPoints = 3;
    blinkDelay = [TERandom randomFractionFrom:BLINK_MIN to:BLINK_MAX];
  }
  
  return self;
}

-(void)explode {
  self.collide = NO;

  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 0.0;
  scaleAnimation.duration = 0.5;
  scaleAnimation.onRemoval= ^(){
    self.remove = YES;
  };
  [self startAnimation:scaleAnimation];
  
  TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
  rotateAnimation.rotation = [TERandom randomFraction] * 2 * M_TAU;
  rotateAnimation.duration = 0.5;
  [self startAnimation:rotateAnimation];
}

-(void)updateBlink:(NSTimeInterval)dt {
  if (blinkDelay > 0)
    blinkDelay -= dt;
  if (blinkDelay <= 0)
    [self blink];
}

-(void)blink {
  blinkDelay = [TERandom randomFractionFrom:BLINK_MIN to:BLINK_MAX];
}

@end