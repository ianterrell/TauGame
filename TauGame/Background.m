//
//  Background.m
//  TauGame
//
//  Created by Ian Terrell on 7/31/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Background.h"

@implementation Background

- (id)initInScene:(TEScene *)scene
{
  self = [super init];
  if (self) {
    TERegularPolygon *shape = [[TERegularPolygon alloc] initWithSides:4];
    shape.radius = MAX(scene.topRightVisible.x - scene.bottomLeftVisible.x, scene.topRightVisible.y - scene.bottomLeftVisible.y);
    shape.node = self;
    shape.renderStyle = kTERenderStyleVertexColors;
    
    time = 0;
    radius = MIN(scene.topRightVisible.x - scene.bottomLeftVisible.x, scene.topRightVisible.y - scene.bottomLeftVisible.y)/3;
    
    shape.colorVertices[0] = GLKVector4Make(0,0,0.3,1);
    for (int i = 1; i < shape.numVertices; i++)
      shape.colorVertices[i] = GLKVector4Make(0,0,0.1,1);
    
    self.drawable = shape;
    self.position = GLKVector2Make((scene.topRightVisible.x + scene.bottomLeftVisible.x)/2, (scene.topRightVisible.y + scene.bottomLeftVisible.y)/2);
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  time += dt;
  self.shape.vertices[0] = GLKVector2Make(sin(time/3)*radius,cos(time/3)*radius);
}

@end