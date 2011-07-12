//
//  TETriangle.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TETriangle.h"

@implementation TETriangle

@synthesize vertex0, vertex1, vertex2;

- (id)init
{
  self = [super init];
  if (self) {
    vertex0 = GLKVector2Make(0.0, 1.0);
    vertex1 = GLKVector2Make(-1.0, -1.0);
    vertex2 = GLKVector2Make(1.0, -1.0);
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  self.effect.constantColor = self.color;
  [self.effect prepareToDraw];

  GLfloat vertices[] = {vertex0.x, vertex0.y, vertex1.x, vertex1.y, vertex2.x, vertex2.y};
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  glDrawArrays(GL_TRIANGLES, 0, 3);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
