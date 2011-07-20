//
//  TENode.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"

@implementation TENode

@synthesize name, shape, children;
@synthesize maxVelocity, maxAcceleration;

- (id)init
{
  self = [super init];
  if (self) {
    velocity = GLKVector2Make(0, 0);
    acceleration = GLKVector2Make(0, 0);
    maxVelocity = INFINITY;
    maxAcceleration = INFINITY;
    self.children = [[NSMutableArray alloc] init];
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  [shape renderInScene:scene];
  [children makeObjectsPerformSelector:@selector(renderInScene:) withObject:scene];
}

# pragma mark Motion Methods

-(void)updatePosition:(NSTimeInterval)dt {
  self.velocity = GLKVector2Add(velocity, GLKVector2MultiplyScalar(acceleration, dt));
  position = GLKVector2Add(position, GLKVector2MultiplyScalar(velocity, dt));
}

-(GLKVector2)velocity {
  return velocity;
}

-(GLKVector2)acceleration {
  return acceleration;
}

-(void)setVelocity:(GLKVector2)newVelocity {
  if (GLKVector2Length(newVelocity) > maxVelocity)
    velocity = GLKVector2MultiplyScalar(GLKVector2Normalize(newVelocity), maxVelocity);
  else
    velocity = newVelocity;
}

-(void)setAcceleration:(GLKVector2)newAcceleration {
  if (GLKVector2Length(newAcceleration) > maxAcceleration)
    acceleration = GLKVector2MultiplyScalar(GLKVector2Normalize(newAcceleration), maxAcceleration);
  else
    acceleration = newAcceleration;
}


# pragma mark Tree Methods

-(void)addChild:(TENode *)child {
  child.parent = self;
  [self.children addObject:child];
}

-(void)traverseUsingBlock:(void (^)(TENode *))block {
  block(self);
  [self.children makeObjectsPerformSelector:@selector(traverseUsingBlock:) withObject:block];
}

@end
