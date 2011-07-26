//
//  TENode.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"
#import "TEAnimation.h"
#import "Box2D.h"

@implementation TENode

@synthesize name, shape, children;
@synthesize maxVelocity, maxAcceleration;
@synthesize maxAngularVelocity, maxAngularAcceleration;
@synthesize remove;
@synthesize collide;

- (id)init
{
  self = [super init];
  if (self) {
    velocity = GLKVector2Make(0, 0);
    acceleration = GLKVector2Make(0, 0);
    maxVelocity = INFINITY;
    maxAcceleration = INFINITY;
    
    angularVelocity = angularAcceleration = 0;
    maxAngularVelocity = maxAngularAcceleration = INFINITY;
    
    remove = NO;
    self.children = [[NSMutableArray alloc] init];
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  [shape renderInScene:scene forNode:self];
  [children makeObjectsPerformSelector:@selector(renderInScene:) withObject:scene];
}

# pragma mark Update

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  // Update positions
  [self updatePosition:dt inScene:scene];
  
  // Update animations
  NSMutableArray *removed = [[NSMutableArray alloc] init];
  [self traverseUsingBlock:^(TENode *node) {
    // Remove animations that are done
    [node.currentAnimations filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TEAnimation *animation, NSDictionary *bindings) {
      if (animation.remove) {
        [removed addObject:animation];
        return NO;
      } else
        return YES;
    }]];
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop) {
      [((TEAnimation *)animation) incrementElapsedTime:dt];
    }];
  }];
  for (TEAnimation *animation in removed)
    if (animation.onRemoval != nil)
      animation.onRemoval();
}

# pragma mark Motion Methods

-(void)updatePosition:(NSTimeInterval)dt inScene:(TEScene *)scene {
  self.velocity = GLKVector2Add(velocity, GLKVector2MultiplyScalar(acceleration, dt));
  position = GLKVector2Add(position, GLKVector2MultiplyScalar(velocity, dt));
  
  self.angularVelocity += angularAcceleration * dt;
  self.rotation += self.angularVelocity * dt;
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

-(float)angularVelocity {
  return angularVelocity;
}

-(float)angularAcceleration {
  return angularAcceleration;
}

-(void)setAngularVelocity:(float)newAngularVelocity {
  angularVelocity = MIN(maxAngularVelocity, newAngularVelocity);
}

-(void)setAngularAcceleration:(float)newAngularAcceleration {
  angularAcceleration = MIN(maxAngularAcceleration, newAngularAcceleration);
}


# pragma mark Position Shortcuts

-(void)wraparoundInScene:(TEScene *)scene {
  [self wraparoundXInScene:scene];
  [self wraparoundYInScene:scene];
}

-(void)wraparoundXInScene:(TEScene *)scene {
  if (self.position.x > scene.topRightVisible.x)
    self.position = GLKVector2Make(scene.bottomLeftVisible.x, self.position.y);
  else if (self.position.x < scene.bottomLeftVisible.x)
    self.position = GLKVector2Make(scene.topRightVisible.x, self.position.y);
}

-(void)wraparoundYInScene:(TEScene *)scene {
  if (self.position.y > scene.topRightVisible.y)
    self.position = GLKVector2Make(self.position.x, scene.bottomLeftVisible.y);
  else if (self.position.y < scene.bottomLeftVisible.y)
    self.position = GLKVector2Make(self.position.x, scene.topRightVisible.y);
}

-(void)removeOutOfScene:(TEScene *)scene buffer:(float)buffer {
  if (self.position.y < scene.bottomLeftVisible.y - buffer || self.position.y > scene.topRightVisible.y + buffer ||
      self.position.x < scene.bottomLeftVisible.x - buffer || self.position.x > scene.topRightVisible.x + buffer)
    self.remove = YES;
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

# pragma mark Collision Detection

-(void *)collisionShape {
  return collisionShape;
}

-(void)setCollisionShape:(void *)_collisionShape {
  collisionShape = _collisionShape;
}

# pragma mark Callbacks

-(void)onRemovalFromScene:(TEScene *)scene {
}

# pragma mark Cleanup

-(void)dealloc {
  if (collisionShape != nil) {
    if ([shape isPolygon])
      delete (b2PolygonShape *)collisionShape;
    else
      delete (b2CircleShape *)collisionShape;
  }
}

@end
