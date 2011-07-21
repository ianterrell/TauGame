//
//  TETriangle.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TETriangle.h"

@implementation TETriangle

- (id)init
{
  self = [super init];
  if (self) {
    self.vertex0 = GLKVector2Make(0.0, 1.0);
    self.vertex1 = GLKVector2Make(-1.0, -1.0);
    self.vertex2 = GLKVector2Make(1.0, -1.0);
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  self.effect.constantColor = self.color;
  [self.effect prepareToDraw];
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  glDrawArrays(GL_TRIANGLES, 0, 3);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}

-(GLKVector2)vertex0 {
  return GLKVector2Make(vertices[0],vertices[1]);
}

-(GLKVector2)vertex1 {
  return GLKVector2Make(vertices[2],vertices[3]);
}

-(GLKVector2)vertex2 {
  return GLKVector2Make(vertices[4],vertices[5]);
}

-(void)setVertex0:(GLKVector2)vertex {
  vertices[0] = vertex.x;
  vertices[1] = vertex.y;
}

-(void)setVertex1:(GLKVector2)vertex {
  vertices[2] = vertex.x;
  vertices[3] = vertex.y;
}

-(void)setVertex2:(GLKVector2)vertex {
  vertices[4] = vertex.x;
  vertices[5] = vertex.y;
}

@end
