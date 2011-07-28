//
//  TEPolygon.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEPolygon.h"

@implementation TEPolygon

@synthesize vertices, numVertices;

- (id)initWithVertices:(int)num
{
  self = [super init];
  if (self) {
    vertexData = [NSMutableData dataWithLength:sizeof(GLKVector2)*num];
    vertices = [vertexData mutableBytes];
    numVertices = num;
    radius = 0;
  }
  
  return self;
}

-(BOOL)isPolygon {
  return YES;
}

-(GLenum)renderMode {
  return GL_TRIANGLE_FAN;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  glDrawArrays([self renderMode], 0, [self numVertices]);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}

-(void)setRadius:(float)radius {
  // noop
}

-(float)radius {
  if (radius == 0)
    for (int i = 0; i < numVertices; i++)
      radius = MAX(radius, GLKVector2Length(vertices[i]));
  return radius;
}

@end
