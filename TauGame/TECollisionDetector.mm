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

static b2Manifold manifold;
static b2Transform transform1;
static b2Transform transform2;

typedef enum {
  TECollisionTypePolygonPolygon,
  TECollisionTypePolygonCircle,
  TECollisionTypeCircleCircle
} TECollisionType;

@implementation TECollisionDetector

+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2 type:(TECollisionType)type {
  // TODO SCALE THE OBJECTS
  transform1.Set(b2Vec2(node1.position.x, node1.position.y), node1.rotation);
  transform2.Set(b2Vec2(node2.position.x, node2.position.y), node2.rotation);
  
  if (type == TECollisionTypePolygonPolygon) {
    b2CollidePolygons(&manifold, (b2PolygonShape*)node1.collisionShape, transform1, (b2PolygonShape*)node2.collisionShape, transform2);
  } else if (type == TECollisionTypePolygonCircle) {
    b2CollidePolygonAndCircle(&manifold, (b2PolygonShape*)node1.collisionShape, transform1, (b2CircleShape*)node2.collisionShape, transform2);
  } else if (type == TECollisionTypeCircleCircle) {
    b2CollideCircles(&manifold, (b2CircleShape*)node1.collisionShape, transform1, (b2CircleShape*)node2.collisionShape, transform2);
  }
  
  return manifold.pointCount > 0;
}


+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2 {
  if (!node1.collide || !node2.collide) {
    return NO;
  } else {
    if ([node1.shape isPolygon]) {
      if ([node2.shape isPolygon])
        return [self node:node1 collidesWithNode:node2 type:TECollisionTypePolygonPolygon];
      else
        return [self node:node1 collidesWithNode:node2 type:TECollisionTypePolygonCircle];
    } else {
      if ([node2.shape isPolygon])
        return [self node:node2 collidesWithNode:node1 type:TECollisionTypePolygonCircle];
      else
        return [self node:node1 collidesWithNode:node2 type:TECollisionTypeCircleCircle];
    }
  }
}

+(NSMutableArray *)collisionsIn:(NSArray *)nodes {
  return [self collisionsIn:nodes maxPerNode:0];
}
                                
+(NSMutableArray *)collisionsIn:(NSArray *)nodes maxPerNode:(int)n {
  NSMutableArray *collisions = [[NSMutableArray alloc] init];
  [self collisionsIn:nodes maxPerNode:n withBlock:^(TENode *node1, TENode *node2) {
    [collisions addObject:[[NSArray alloc] initWithObjects:node1, node2, nil]];
  }];
  return collisions;
}

+(void)collisionsIn:(NSArray *)nodes withBlock:(void (^)(TENode *, TENode *))block {
  return [self collisionsIn:nodes maxPerNode:0 withBlock:block];
}

+(void)collisionsIn:(NSArray *)nodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  int size = [nodes count];
  for (int i = 0; i < size; i++) {
    int count = 0;
    for (int j = i + 1; j < size; j++) {
      TENode *node1 = (TENode *)[nodes objectAtIndex:i];
      TENode *node2 = (TENode *)[nodes objectAtIndex:j];
      if ([self node:node1 collidesWithNode:node2]) {
        block(node1,node2);
        if (n > 0 && ++count >= n)
          break;
      }
    }
  }
}

+(NSMutableArray *)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes {
  return [self collisionsBetween:nodes andNodes:moreNodes maxPerNode:0];
}

+(NSMutableArray *)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes maxPerNode:(int)n {
  NSMutableArray *collisions = [[NSMutableArray alloc] init];
  [self collisionsBetween:nodes andNodes:moreNodes maxPerNode:n withBlock:^(TENode *node1, TENode *node2) {
    [collisions addObject:[[NSArray alloc] initWithObjects:node1, node2, nil]];
  }];
  return collisions;
}

+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes withBlock:(void (^)(TENode *, TENode *))block {
  return [self collisionsBetween:nodes andNodes:moreNodes maxPerNode:0 withBlock:block];
}

+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  for (TENode *node1 in nodes) {
    int count = 0;
    for (TENode *node2 in moreNodes) {
      if ([self node:node1 collidesWithNode:node2]) {
        block(node1,node2);
        if (n > 0 && ++count >= n)
          break;
      }
    }
  }
}

-(void)test {
  b2Manifold manifold;
  b2Transform transform1;
  b2Transform transform2;
  
  b2CircleShape circle1;
  circle1.m_radius = 5.0;
  
  b2CircleShape circle2;
  circle2.m_radius = 5.0;
  
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
  
  transform1.Set(b2Vec2(0.0, 6.1), 1.0/8.0*M_TAU);
  transform2.Set(b2Vec2(0.0, 0.0), 0.0);
  b2CollidePolygonAndCircle(&manifold, &box, transform1, &circle1, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"box and circle collide with box at 6.1 rotated 1/8 tau");
  }
  
  NSLog(@"YO BOYS IT'S OBJ-C++ TIME");
  TENode *node = [[TENode alloc] init];
  node.collisionShape = &circle1;
  b2CollidePolygonAndCircle(&manifold, &box, transform1, (b2CircleShape*)node.collisionShape, transform2);
  if (manifold.pointCount > 0){
    NSLog(@"TOTALLY COLLIDED RIGHT");
  }
}

@end
