//
//  Asteroid.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Asteroid.h"

@implementation Asteroid

- (id)init
{
  self = [super init];
  if (self) {
    for (int i = 0; i < [TERandom randomFrom:2 to:6]; i++) {
      TENode *triangleNode = [[TENode alloc] init];
      TETriangle *triangleShape = [[TETriangle alloc] init];
      
      triangleShape.color = GLKVector4Make(1, 1, 1, 1);
      triangleShape.vertex0 = GLKVector2Make(0, [TERandom randomFractionFrom:0.5 to:1.5]);
      triangleShape.vertex1 = GLKVector2Make([TERandom randomFractionFrom:-1.5 to:-0.5], 0);
      triangleShape.vertex2 = GLKVector2Make([TERandom randomFractionFrom:0.5 to:1.5], 0);
      triangleShape.parent = triangleNode;
      
      triangleNode.shape = triangleShape;
      triangleNode.parent = self;
      triangleNode.rotation = ((float)rand()/RAND_MAX)*M_TAU;
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
