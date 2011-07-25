//
//  TEShape.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"
#import "TEEllipse.h"

@implementation TEShape

@synthesize color;

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

-(void)updateVertices {
}

-(void)renderInScene:(TEScene *)scene forNode:(TENode *)node {
  // Set up matrices
  [super renderInScene:scene];
  
  // Set the color
  self.effect.constantColor = self.color;
  [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
    if ([animation isKindOfClass:[TEColorAnimation class]]) {
      TEColorAnimation *colorAnimation = (TEColorAnimation *)animation;
      self.effect.constantColor = GLKVector4Add(self.effect.constantColor, colorAnimation.easedColor);
    }
  }];
  
  // Finalize effect
  [self.effect prepareToDraw];
}

-(BOOL)isPolygon {
  return ![self isCircle];
}

-(BOOL)isCircle {
  return [self isKindOfClass:[TEEllipse class]];
}

@end
