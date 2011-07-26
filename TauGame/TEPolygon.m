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
    vertexData = [NSMutableData dataWithLength:sizeof(GLKVector2)*numVertices];
    vertices = [vertexData mutableBytes];
    numVertices = num;
  }
  
  return self;
}

-(GLenum)renderMode {
  return GL_TRIANGLE_FAN;
}

-(void)renderInScene:(TEScene *)scene forNode:(TENode *)node  {
  [super renderInScene:scene forNode:node];
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  glDrawArrays([self renderMode], 0, [self numVertices]);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}

@end
