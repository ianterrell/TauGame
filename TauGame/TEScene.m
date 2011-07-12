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
  NSLog(@"Rendering scene %@", self);
  
  glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [characters makeObjectsPerformSelector:@selector(renderInScene:) withObject:self];
  
  
  
//  GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
//  effect.constantColor = GLKVector4Make(1.0, 0.0, 0.0, 1.0);
//  effect.useConstantColor = GL_TRUE;
//  
//  GLKMatrix4 modelViewMatrix;
//  modelViewMatrix = GLKMatrix4MakeScale(10, 10, 10);
//  effect.transform.modelviewMatrix = modelViewMatrix;  
//  effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-80, 80, -120, 120, 1.0, -1.0);
//  [effect prepareToDraw];
//  
//  static const GLfloat squareVertices[] = {
//    -1.0f, -1.0f,
//    1.0f, -1.0f,
//    -1.0f,  1.0f,
//    1.0f,  1.0f,
//  };
//  
//  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
//  glClear(GL_COLOR_BUFFER_BIT);
//  
//  glEnableVertexAttribArray(GLKVertexAttribPosition);
//  
//  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, squareVertices);
//  
//  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//  
//  glDisableVertexAttribArray(GLKVertexAttribPosition);
  
}

- (GLKBaseEffect *)constantColorEffect {
  GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
  effect.useConstantColor = GL_TRUE;
  return effect;
}


-(GLKMatrix4)projectionMatrix {
  return GLKMatrix4MakeOrtho(left, right, bottom, top, 1.0, -1.0);
}

@end
