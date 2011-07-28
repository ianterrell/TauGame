//
//  TEDrawable.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"
#import "TauEngine.h"

@implementation TEDrawable

@synthesize node, effect, renderStyle, color;

- (id)init
{
  self = [super init];
  if (self) {
    renderStyle = kTERenderStyleConstantColor;
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  self.effect = [scene constantColorEffect];
  self.effect.transform.modelviewMatrix = [node modelViewMatrix];
  self.effect.transform.projectionMatrix = [scene projectionMatrix];
  
  // Set up the effect
  if (renderStyle == kTERenderStyleConstantColor) {
    self.effect.constantColor = self.color;
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
      if ([animation isKindOfClass:[TEColorAnimation class]]) {
        TEColorAnimation *colorAnimation = (TEColorAnimation *)animation;
        self.effect.constantColor = GLKVector4Add(self.effect.constantColor, colorAnimation.easedColor);
      }
    }];
  } else if (renderStyle == kTERenderStyleTexture) {
    
  }
  
  // Finalize effect
  [self.effect prepareToDraw];
}

@end
