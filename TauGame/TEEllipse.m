//
//  TEEllipse.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "TEEllipse.h"

#define RESOLUTION 62
#define NUM_VERTICES (RESOLUTION + 2)

@implementation TEEllipse

- (id)init
{
  self = [super init];
  if (self) {
    radiusX = radiusY = 1.0;
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  self.effect.constantColor = self.color;
  [self.effect prepareToDraw];
  
  GLfloat vertices[2*NUM_VERTICES];
  vertices[0] = vertices[1] = 0.0;
  
  for (int i = 0; i <= RESOLUTION; i++) {
    float theta = ((float)i) / RESOLUTION * M_TAU;
    vertices[2+i*2] = cos(theta)*radiusX;
    vertices[2+i*2+1] = sin(theta)*radiusY;
  }
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  glDrawArrays(GL_TRIANGLE_FAN, 0, NUM_VERTICES);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
