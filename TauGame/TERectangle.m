//
//  TERectangle.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TERectangle.h"

@implementation TERectangle

- (id)init
{
  self = [super init];
  if (self) {
    width = height = 1.0;
    [self updateVertices];
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  self.effect.constantColor = self.color;
  [self.effect prepareToDraw];
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}

-(void)updateVertices {
  vertices[0] = width/2;
  vertices[1] = -height/2;
  vertices[2] = width/2;
  vertices[3] = height/2;
  vertices[4] = -width/2;
  vertices[5] = height/2;
  vertices[6] = -width/2;
  vertices[7] =-height/2;
}

-(GLfloat)height {
  return height;
}

-(void)setHeight:(GLfloat)_height {
  self.height = _height;
  [self updateVertices];
}

-(GLfloat)width {
  return width;
}

-(void)setWidth:(GLfloat)_width {
  self.width = _width;
  [self updateVertices];
}

@end
