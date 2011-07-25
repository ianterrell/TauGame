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

+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2 recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight {
  __block BOOL collision = NO;
  
  if (recurseLeft) {
    [node1 traverseUsingBlock:^(TENode *leftNode) {
      if (recurseRight) {
        [node2 traverseUsingBlock:^(TENode *rightNode) {
          if (!collision && [self node:leftNode collidesWithNode:rightNode]) // TODO: no need for !collision if we had a BOOL* break in traverseUsingBlock:
            collision = YES;
        }];
      } else {
        if (!collision && [self node:leftNode collidesWithNode:node2])
          collision = YES;
      }
    }];
  } else {
    if (recurseRight) {
      [node2 traverseUsingBlock:^(TENode *rightNode) {
        if (!collision && [self node:node1 collidesWithNode:rightNode])
          collision = YES;
      }];
    } else {
      if (!collision && [self node:node1 collidesWithNode:node2])
        collision = YES;
    }
  }

  return collision;
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
  [self collisionsIn:nodes recurseLeft:NO recurseRight:NO maxPerNode:n withBlock:block];
}

+(void)collisionsIn:(NSArray *)nodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  int size = [nodes count];
  for (int i = 0; i < size; i++) {
    int count = 0;
    for (int j = i + 1; j < size; j++) {
      TENode *node1 = (TENode *)[nodes objectAtIndex:i];
      TENode *node2 = (TENode *)[nodes objectAtIndex:j];
      if ([self node:node1 collidesWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight]) {
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
  [self collisionsBetween:nodes andNodes:moreNodes recurseLeft:NO recurseRight:NO maxPerNode:n withBlock:block];
}

+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  for (TENode *node1 in nodes) {
    int count = 0;
    for (TENode *node2 in moreNodes) {
      if ([self node:node1 collidesWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight]) {
        block(node1,node2);
        if (n > 0 && ++count >= n)
          break;
      }
    }
  }
}

@end
