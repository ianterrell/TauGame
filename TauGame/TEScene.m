//
//  TEScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"

@implementation TEScene

@synthesize left, right, bottom, top;
@synthesize clearColor;
@synthesize characters;

- (id)init {
  self = [super init];
  if (self) {
    self.characters = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self render];
}

# pragma mark Scene Setup

-(void)setLeft:(GLfloat)_left right:(GLfloat)_right bottom:(GLfloat)_bottom top:(GLfloat)_top {
  self.left = _left;
  self.right = _right;
  self.bottom = _bottom;
  self.top = _top;
}

# pragma mark Rendering

-(void)render {
  glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [characters makeObjectsPerformSelector:@selector(renderInScene:) withObject:self];
}

- (GLKBaseEffect *)constantColorEffect {
  if (!constantColorEffect) {
    constantColorEffect = [[GLKBaseEffect alloc] init];
    constantColorEffect.useConstantColor = GL_TRUE;
  }
  return constantColorEffect;
}

-(GLKMatrix4)projectionMatrix {
  return GLKMatrix4MakeOrtho(left, right, bottom, top, 1.0, -1.0);
}

@end
