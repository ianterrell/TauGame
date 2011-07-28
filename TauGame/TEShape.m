//
//  TEShape.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"
#import "TEEllipse.h"

static GLKBaseEffect *constantColorEffect;

@implementation TEShape

@synthesize effect, renderStyle, color;

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

-(void)updateVertices {
}

-(BOOL)isPolygon {
  return ![self isCircle];
}

-(BOOL)isCircle {
  return [self isKindOfClass:[TEEllipse class]];
}

-(float)radius {
  return 0.0;
}

@end
