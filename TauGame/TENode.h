//
//  TENode.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"
#import "TEShape.h"
#import "TEScene.h"

@interface TENode : TEDrawable {
  NSString *name;
  TEShape *shape;
  NSMutableArray *children;
  
  GLKVector2 velocity, acceleration;
  float maxVelocity, maxAcceleration;

  BOOL remove;
}

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) TEShape *shape;
@property(strong, nonatomic) NSMutableArray *children;
@property GLKVector2 velocity, acceleration;
@property float maxVelocity, maxAcceleration;
@property BOOL remove;

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

@end
