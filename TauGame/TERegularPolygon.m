//
//  TERegularPolygon.m
//  TauGame
//
//  Created by Ian Terrell on 7/27/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "TERegularPolygon.h"

@implementation TERegularPolygon

-(id)initWithSides:(int)num
{
  self = [super initWithVertices:num+2];
  if (self) {
    numSides = num;
    self.radius = 1.0;
  }
  
  return self;
}

-(void)updateVertices {
  vertices[0] = GLKVector2Make(0,0);
  for (int i = 0; i <= numSides; i++) {
    float theta = ((float)i) / numSides * M_TAU;
    vertices[i+1] = GLKVector2Make(cos(theta)*radius, sin(theta)*radius);
  }
}

-(void)setRadius:(float)_radius {
  radius = _radius;
  [self updateVertices];
}


@end
