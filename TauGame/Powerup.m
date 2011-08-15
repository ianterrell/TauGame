//
//  Powerup.m
//  TauGame
//
//  Created by Ian Terrell on 7/27/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Powerup.h"
#import "TauEngine.h"

#define POWERUP_VELOCITY -1
#define POWERUP_ACCELERATION -3

@implementation Powerup

+(void)addPowerupToScene:(Game *)scene at:(GLKVector2)location {
  Powerup *powerup = [[self alloc] init];
  powerup.velocity = GLKVector2Make(0,POWERUP_VELOCITY);
  powerup.acceleration = GLKVector2Make(0,POWERUP_ACCELERATION);
  powerup.angularVelocity = 0.5*M_TAU;
  powerup.position = location;
  [scene.characters addObject:powerup];
  [scene.powerups addObject:powerup];
}

-(void)update:(NSTimeInterval)dt inScene:(Game *)scene {
  [super update:dt inScene:scene];
  [self removeOutOfScene:scene buffer:2.0];
}

-(void)die {
  self.collide = NO;
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 0.0;
  scaleAnimation.duration = 0.1;
  scaleAnimation.onRemoval= ^(){
    self.remove = YES;
  };
  [self.currentAnimations addObject:scaleAnimation];
}

-(void)setInnerColor:(GLKVector4)inner outerColor:(GLKVector4)outer {
  self.shape.renderStyle = kTERenderStyleVertexColors;
  self.shape.colorVertices[0] = inner;
  for (int i = 1; i < self.shape.numVertices; i++)
    self.shape.colorVertices[i] = outer;
}

@end
