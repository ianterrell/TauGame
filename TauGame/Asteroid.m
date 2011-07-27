//
//  Asteroid.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Asteroid.h"
#import "AsteroidField.h"

@implementation Asteroid

- (id)init
{
  self = [super init];
  
  if (self) {
    GLKVector4 color = GLKVector4Make([TERandom randomFractionFrom:0.7 to:0.9], [TERandom randomFractionFrom:0.7 to:0.9], [TERandom randomFractionFrom:0.7 to:0.9], 1);
    self.collide = YES;
    
    for (int i = 0; i < [TERandom randomFrom:2 to:6]; i++) {
      TENode *triangleNode = [[TENode alloc] init];
      
      // Set up shape
      TETriangle *triangleShape = [[TETriangle alloc] init];
      triangleShape.color = color;
      triangleShape.vertices[0] = GLKVector2Make(0, [TERandom randomFractionFrom:0.5 to:1.5]);
      triangleShape.vertices[1] = GLKVector2Make([TERandom randomFractionFrom:-1.5 to:-0.5], 0);
      triangleShape.vertices[2] = GLKVector2Make([TERandom randomFractionFrom:0.5 to:1.5], 0);
      triangleShape.parent = triangleNode;
      
      // Set up node
      triangleNode.shape = triangleShape;
      triangleNode.parent = self;
      triangleNode.rotation = ((float)rand()/RAND_MAX)*M_TAU;
      triangleNode.collide = YES;
      
      [self.children addObject:triangleNode];
    }
    
    self.scale = [TERandom randomFractionFrom:0.25 to:1.25];
    self.angularVelocity = [TERandom randomFraction]*M_TAU;
    self.velocity = GLKVector2Make(0, [TERandom randomFractionFrom:-3.0 to:-1.0]);
    
    hitPoints = self.scale * 4;
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self removeOutOfScene:scene buffer:2.0];
}

-(void)registerHit {
  [[TESoundManager sharedManager] play:@"hurt"];
  hitPoints--;
  
  TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
  highlight.color = GLKVector4Make(1, 1, 1, 1);
  highlight.duration = 0.1;
  
  BOOL dead = hitPoints <= 0;
  
  [self traverseUsingBlock:^(TENode *node){
    [node.currentAnimations addObject:highlight];
    
    if (dead) {
      node.collide = NO;
      
      if (node != self) {
        TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
        rotateAnimation.rotation = [TERandom randomFractionFrom:-2 to:2] * M_TAU;
        rotateAnimation.duration = 0.5;
        [node.currentAnimations addObject:rotateAnimation];

        TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
        translateAnimation.translation = GLKVector2Make([TERandom randomFractionFrom:-5 to:5], [TERandom randomFractionFrom:-5 to:5]);
        translateAnimation.duration = 0.5;
        [node.currentAnimations addObject:translateAnimation];
        
        [node markModelViewMatrixDirty];
      }
    }
  }];
  
  if (dead) {
    TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
    scaleAnimation.scale = 0.0;
    scaleAnimation.duration = 0.5;
    scaleAnimation.onRemoval= ^(){
      self.remove = YES;
    };
    [self.currentAnimations addObject:scaleAnimation];
  }
}

-(void)onRemovalFromScene:(TEScene *)scene {
  [((AsteroidField *)scene).asteroids removeObject:self];
}

@end
