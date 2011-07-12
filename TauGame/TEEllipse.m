//
//  TEEllipse.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "TEEllipse.h"

@implementation TEEllipse

- (id)init
{
  self = [super init];
  if (self) {
    radiusX = radiusY = 1.0;
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
  glDrawArrays(GL_TRIANGLE_FAN, 0, TE_ELLIPSE_NUM_VERTICES);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}


-(void)updateVertices {
  vertices[0] = vertices[1] = 0.0;
  for (int i = 0; i <= TE_ELLIPSE_RESOLUTION; i++) {
    float theta = ((float)i) / TE_ELLIPSE_RESOLUTION * M_TAU;
    vertices[2+i*2] = cos(theta)*radiusX;
    vertices[2+i*2+1] = sin(theta)*radiusY;
  }
}

-(GLfloat)radiusX {
  return radiusX;
}

-(void)setRadiusX:(GLfloat)_radiusX {
  self.radiusX = _radiusX;
  [self updateVertices];
}

-(GLfloat)radiusY {
  return radiusY;
}

-(void)setRadiusY:(GLfloat)_radiusY {
  self.radiusY = _radiusY;
  [self updateVertices];
}

@end
