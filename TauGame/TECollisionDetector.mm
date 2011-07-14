//
//  TECollisionDetector.m
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECollisionDetector.h"
#import "TauEngine.h"
#import "Box2D.h"

@implementation TECollisionDetector

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

-(void)test {
  b2Manifold manifold;
  b2Transform transform1;
  b2Transform transform2;
  
  b2CircleShape circle1;
  circle1.m_radius = 5.0;
  
  b2CircleShape circle2;
  circle2.m_radius = 5.0;
  b2Vec2 circle2Pos(0.0, 0.0);
  
  b2PolygonShape triangle;
  b2Vec2 vertices[3];
  vertices[0] = b2Vec2(0.0, 0.0);
  vertices[1] = b2Vec2(2.0, 0.0);
  vertices[2] = b2Vec2(0.0, 2.0);
  triangle.Set(vertices, 3);
  
  b2PolygonShape box;
  box.SetAsBox(1.0, 1.0, b2Vec2(0.0, 0.0), 0.0);
  
  transform1.Set(b2Vec2(0.0, 0.0), 0.0);
  transform2.Set(b2Vec2(9.0, 0.0), 0.0);
  b2CollideCircles(&manifold, &circle1, transform1, &circle2, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"circles collide at 0.0 and 9.0");
  }
  
  transform1.Set(b2Vec2(0.0, 0.0), 0.0);
  transform2.Set(b2Vec2(11.0, 0.0), 0.0);
  b2CollideCircles(&manifold, &circle1, transform1, &circle2, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"circles collide at 0.0 and 11.0");
  }  
  
  transform1.Set(b2Vec2(0.0, 0.0), 0.0);
  transform2.Set(b2Vec2(0.0, 2.0), 0.0);
  b2CollidePolygons(&manifold, &triangle, transform1, &box, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"triangle and box collide with box at 2.0");
  }
  
  transform1.Set(b2Vec2(0.0, 0.0), 0.0);
  transform2.Set(b2Vec2(0.0, 3.1), 0.0);
  b2CollidePolygons(&manifold, &triangle, transform1, &box, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"triangle and box collide with box at 3.1");
  }
  
  transform1.Set(b2Vec2(0.0, 0.0), 0.0);
  transform2.Set(b2Vec2(0.0, 3.1), 1.0/8.0*M_TAU);
  b2CollidePolygons(&manifold, &triangle, transform1, &box, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"triangle and box collide with box at 3.1 rotated 1/8 tau");
  }

  transform1.Set(b2Vec2(0.0, 5.0), 0.0);
  transform2.Set(b2Vec2(0.0, 0.0), 0.0);
  b2CollidePolygonAndCircle(&manifold, &box, transform1, &circle1, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"box and circle collide with box at 5.0");
  }
  
  transform1.Set(b2Vec2(0.0, 6.1), 0.0);
  transform2.Set(b2Vec2(0.0, 0.0), 0.0);
  b2CollidePolygonAndCircle(&manifold, &box, transform1, &circle1, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"box and circle collide with box at 6.1");
  }
  
  transform2.Set(b2Vec2(0.0, 6.1), 1.0/8.0*M_TAU);
  transform2.Set(b2Vec2(0.0, 0.0), 0.0);
  b2CollidePolygonAndCircle(&manifold, &box, transform1, &circle1, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"box and circle collide with box at 6.1 rotated 1/8 tau");
  }
}

@end
