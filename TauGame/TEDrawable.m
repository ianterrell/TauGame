//
//  TEDrawable.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"
#import "TauEngine.h"

static GLKBaseEffect *constantColorEffect;

@implementation TEDrawable

@synthesize node, effect, renderStyle, color;

+(void)initialize {
  constantColorEffect = [[GLKBaseEffect alloc] init];
  constantColorEffect.useConstantColor = YES;
}

- (id)init
{
  self = [super init];
  if (self) {
    renderStyle = kTERenderStyleConstantColor;
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  // Create the effect if necessary
  if (effect == nil) {
    switch (renderStyle) {
      case kTERenderStyleConstantColor:
        effect = constantColorEffect;
        break;
      default:
        break;
    }
  }
  
  effect.transform.modelviewMatrix = [node modelViewMatrix];
  effect.transform.projectionMatrix = [scene projectionMatrix];
  
  // Set up effect specifics
  if (renderStyle == kTERenderStyleConstantColor) {
    effect.constantColor = color;
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
      if ([animation isKindOfClass:[TEColorAnimation class]]) {
        TEColorAnimation *colorAnimation = (TEColorAnimation *)animation;
        effect.constantColor = GLKVector4Add(self.effect.constantColor, colorAnimation.easedColor);
      }
    }];
  }
  
  // Finalize effect
  [effect prepareToDraw];
}

@end
