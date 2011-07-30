//
//  TENode.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"
#import "TEScene.h"
#import "TEShape.h"

@interface TENode : NSObject {
  NSString *name;
  TEDrawable *drawable;
  
  GLKVector2 position, velocity, acceleration;
  float rotation, angularVelocity, angularAcceleration;
  float scale;
  
  float maxVelocity, maxAcceleration;
  float maxAngularVelocity, maxAngularAcceleration;
  
  NSMutableArray *currentAnimations;
  
  TENode *parent;
  NSMutableArray *children;
  
  BOOL remove;
  BOOL collide;
  
  GLKMatrix4 cachedObjectModelViewMatrix, cachedFullModelViewMatrix;
  BOOL dirtyObjectModelViewMatrix, dirtyFullModelViewMatrix;
}

@property GLKVector2 position, velocity, acceleration;
@property float scale;
@property float rotation, angularVelocity, angularAcceleration;
@property(strong, nonatomic) NSMutableArray *currentAnimations;
@property BOOL dirtyFullModelViewMatrix; // can be marked by parents

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) TEDrawable *drawable;
@property(readonly) TEShape *shape;
@property(strong, nonatomic) TENode *parent;
@property(strong, nonatomic) NSMutableArray *children;
@property float maxVelocity, maxAcceleration, maxAngularVelocity, maxAngularAcceleration;
@property BOOL remove;
@property BOOL collide;

# pragma mark Update
-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene;

# pragma mark Motion Methods
-(void)updatePosition:(NSTimeInterval)dt inScene:(TEScene *)scene;

# pragma mark Position Shortcuts
-(void)wraparoundInScene:(TEScene *)scene;
-(void)wraparoundXInScene:(TEScene *)scene;
-(void)wraparoundYInScene:(TEScene *)scene;

-(void)removeOutOfScene:(TEScene *)scene buffer:(float)buffer;

# pragma mark Tree Methods

-(void)addChild:(TENode *)child;
-(void)traverseUsingBlock:(void (^)(TENode *))block;

# pragma mark Callbacks

-(void)onRemoval;

# pragma mark Communicating with outside world

-(void)postNotification:(NSString *)notificationName;

# pragma mark Rendering

-(void)renderInScene:(TEScene *)scene;

# pragma mark Matrix Methods

-(GLKMatrix4)modelViewMatrix;
-(void)markModelViewMatrixDirty;

@end
