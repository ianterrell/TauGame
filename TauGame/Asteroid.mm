//
//  Asteroid.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Asteroid.h"
#import "Box2D.h"

@implementation Asteroid

- (id)init
{
  self = [super init];
  
  
  if (self) {
    GLKVector4 color = GLKVector4Make([TERandom randomFractionFrom:0.7 to:0.9], [TERandom randomFractionFrom:0.7 to:0.9], [TERandom randomFractionFrom:0.7 to:0.9], 1);
    self.collide = YES;
    
    for (int i = 0; i < [TERandom randomFrom:2 to:6]; i++) {
      TENode *triangleNode = [[TENode alloc] init];
      
      // Set up shape
      TETriangle *triangleShape = [[TETriangle alloc] init];
      triangleShape.color = color;
      triangleShape.vertices[0] = GLKVector2Make(0, [TERandom randomFractionFrom:0.5 to:1.5]);
      triangleShape.vertices[1] = GLKVector2Make([TERandom randomFractionFrom:-1.5 to:-0.5], 0);
      triangleShape.vertices[2] = GLKVector2Make([TERandom randomFractionFrom:0.5 to:1.5], 0);
      triangleShape.parent = triangleNode;
      
      // Set up collisions
      b2PolygonShape *triangle = new b2PolygonShape();
      b2Vec2 vertices[3];
      vertices[0] = b2Vec2(triangleShape.vertices[0].x, triangleShape.vertices[0].y);
      vertices[1] = b2Vec2(triangleShape.vertices[1].x, triangleShape.vertices[1].y);
      vertices[2] = b2Vec2(triangleShape.vertices[2].x, triangleShape.vertices[2].y);
      triangle->Set(vertices, 3);
      
      // Set up node
      triangleNode.collisionShape = (void *)triangle;
      triangleNode.shape = triangleShape;
      triangleNode.parent = self;
      triangleNode.rotation = ((float)rand()/RAND_MAX)*M_TAU;
      triangleNode.collide = YES;
      
      [self.children addObject:triangleNode];
    }
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self removeOutOfScene:scene buffer:2.0];
}

@end
