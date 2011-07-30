//
//  TENode.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"
#import "TauEngine.h"

@implementation TENode

@synthesize name, drawable;
@synthesize maxVelocity, maxAcceleration;
@synthesize maxAngularVelocity, maxAngularAcceleration;
@synthesize remove;
@synthesize collide;
@synthesize parent, children;
@synthesize currentAnimations, dirtyFullModelViewMatrix;

- (id)init
{
  self = [super init];
  if (self) {
    scale = 1.0;
    rotation = 0.0;
    position = GLKVector2Make(0.0, 0.0);
    
    velocity = GLKVector2Make(0, 0);
    acceleration = GLKVector2Make(0, 0);
    maxVelocity = INFINITY;
    maxAcceleration = INFINITY;
    
    angularVelocity = angularAcceleration = 0;
    maxAngularVelocity = maxAngularAcceleration = INFINITY;
    
    currentAnimations = [[NSMutableArray alloc] init];
    
    remove = NO;
    self.children = [[NSMutableArray alloc] init];
    
    dirtyObjectModelViewMatrix = YES;
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [drawable renderInScene:scene];
  [children makeObjectsPerformSelector:@selector(renderInScene:) withObject:scene];
}

# pragma mark Update

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  // Update positions
  [self updatePosition:dt inScene:scene];
  
  // Update animations
  [self traverseUsingBlock:^(TENode *node) {
    NSMutableArray *removed = [[NSMutableArray alloc] init];
    // Remove animations that are done
    [node.currentAnimations filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TEAnimation *animation, NSDictionary *bindings) {
      if (animation.remove) {
        [removed addObject:animation];
        return NO;
      } else
        return YES;
    }]];
    
    for (TEAnimation *animation in removed) {
      if (animation.next != nil)
        [node.currentAnimations addObject:animation.next];
      if (animation.onRemoval != nil)
        animation.onRemoval();
    }
    
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop) {
      [((TEAnimation *)animation) incrementElapsedTime:dt];
    }];
  }];
}

# pragma mark Motion Methods

-(GLKVector2)position {
  return position;
}

-(void)setPosition:(GLKVector2)_position {
  position = _position;
  [self markModelViewMatrixDirty];
}

-(float)scale {
  return scale;
}

-(void)setScale:(float)_scale {
  scale = _scale;
  [self markModelViewMatrixDirty];
}

-(float)rotation {
  return rotation;
}

-(void)setRotation:(float)_rotation {
  rotation = _rotation;
  [self markModelViewMatrixDirty];
}

-(void)updatePosition:(NSTimeInterval)dt inScene:(TEScene *)scene {
  self.velocity = GLKVector2Add(velocity, GLKVector2MultiplyScalar(acceleration, dt));
  self.position = GLKVector2Add(position, GLKVector2MultiplyScalar(velocity, dt));
  
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


# pragma mark Callbacks

-(void)onRemoval {
}

# pragma mark Communicating with outside world

-(void)postNotification:(NSString *)notificationName {
  [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

# pragma mark - Drawable Methods

-(TEShape *)shape {
  return (TEShape *)drawable;
}

# pragma mark - Matrix Methods

-(GLKMatrix4)modelViewMatrix {
  if (dirtyObjectModelViewMatrix) {
    __block GLKVector2 mvTranslation = position;
    __block GLfloat mvScale = scale;
    __block GLfloat mvRotation = rotation;
    
    [currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
      if ([animation isKindOfClass:[TETranslateAnimation class]])
        mvTranslation = GLKVector2Add(mvTranslation, ((TETranslateAnimation *)animation).easedTranslation);
      else if ([animation isKindOfClass:[TERotateAnimation class]])
        mvRotation += ((TERotateAnimation *)animation).easedRotation;
      else if ([animation isKindOfClass:[TEScaleAnimation class]])
        mvScale *= ((TEScaleAnimation *)animation).easedScale;
    }];
    
    cachedObjectModelViewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(mvTranslation.x, mvTranslation.y, 0.0),GLKMatrix4MakeScale(mvScale, mvScale, 1.0));
    cachedObjectModelViewMatrix = GLKMatrix4Multiply(cachedObjectModelViewMatrix, GLKMatrix4MakeZRotation(mvRotation));
    if ([self hasCustomTransformation])
      cachedObjectModelViewMatrix = GLKMatrix4Multiply(cachedObjectModelViewMatrix, [self customTransformation]);
    
    dirtyObjectModelViewMatrix = [currentAnimations count] > 0;
    dirtyFullModelViewMatrix = YES;
  }
  
  if (dirtyFullModelViewMatrix) {
    if (parent)
      cachedFullModelViewMatrix = GLKMatrix4Multiply([self.parent modelViewMatrix], cachedObjectModelViewMatrix);
    else if ([TESceneController sharedController].currentScene != nil)
      cachedFullModelViewMatrix = GLKMatrix4Multiply([TESceneController sharedController].currentScene.orientationRotationMatrix, cachedObjectModelViewMatrix);
    else
      cachedFullModelViewMatrix = cachedObjectModelViewMatrix;
    dirtyFullModelViewMatrix = NO;
  }
  
  return cachedFullModelViewMatrix;
}

-(void)markModelViewMatrixDirty {
  dirtyObjectModelViewMatrix = YES;
  
  BOOL tmpSelfValue = self.dirtyFullModelViewMatrix;
  [self traverseUsingBlock:^(TENode *node) {
    node.dirtyFullModelViewMatrix = YES;
  }];
  self.dirtyFullModelViewMatrix = tmpSelfValue;
}

-(BOOL)hasCustomTransformation {
  return NO;
}

-(GLKMatrix4)customTransformation {
  return GLKMatrix4Identity;
}

@end
