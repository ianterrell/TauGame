//
//  TECollisionDetectorTest.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECollisionDetectorTest.h"
#import "TauEngine.h"
#import <GLKit/GLKit.h>

static int count = 0;

@implementation TECollisionDetectorTest

+(TEShape *)circleShape {
  TEEllipse *circle = [[TEEllipse alloc] init];
  circle.radiusX = circle.radiusY = 1.0;
  return circle;
}

+(TENode *)circleNode {
  TENode *node = [[TENode alloc] init];
  node.shape = [self circleShape];
  node.shape.parent = node;
  node.collide = YES;
  return node;
}

+(void)node:(TENode *)node1 shouldCollideWith:(TENode *)node2 label:(NSString *)label {
  count++;
  if ([TECollisionDetector node:node1 collidesWithNode:node2])
    NSLog(@"pass %d — %@", count, label);
  else
    NSLog(@"FAIL %d — %@", count, label);
}

+(void)node:(TENode *)node1 shouldNotCollideWith:(TENode *)node2 label:(NSString *)label {
  count++;
  if (![TECollisionDetector node:node1 collidesWithNode:node2])
    NSLog(@"pass %d — %@", count, label);
  else
    NSLog(@"FAIL %d — %@", count, label);
}

+(void)test {
  //////
  ///// Circle Circle
  ////
  
  TENode *circle1 = [self circleNode];
  TENode *circle2 = [self circleNode];
  
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles overlapping completely"];
  
  circle1.position = GLKVector2Make(0.5,0);
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles overlapping some"];
  
  circle1.position = GLKVector2Make(2,0);
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles touching"];
  
  circle1.position = GLKVector2Make(3,0);
  [self node:circle1 shouldNotCollideWith:circle2 label:@"Circles not touching"];
  
  circle1.position = GLKVector2Make(0,0);//reset
  
  circle1.shape.position = GLKVector2Make(0.5,0);
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles overlapping some; repositioned in shape"];
  
  circle1.shape.position = GLKVector2Make(2,0);
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles touching; repositioned in shape"];
  
  circle1.shape.position = GLKVector2Make(3,0);
  [self node:circle1 shouldNotCollideWith:circle2 label:@"Circles not touching; repositioned in shape"];
}

@end
