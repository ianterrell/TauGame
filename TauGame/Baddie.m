//
//  Baddie.m
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"

@implementation Baddie

- (id)init
{
  self = [super init];
  if (self) {
    hitPoints = 3;
    [TECharacterLoader loadCharacter:self fromJSONFile:@"baddie"];
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self wraparoundInScene:scene];
}

-(void)registerHit {
  [super registerHit];
  
  TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
  highlight.color = GLKVector4Make(1, 1, 1, 1);
  highlight.duration = 0.1;
  [self.currentAnimations addObject:highlight];
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

@end