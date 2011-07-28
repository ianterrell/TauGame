//
//  Asteroid.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Asteroid.h"
#import "AsteroidField.h"

#define NUM_ASTEROID_COLORS 4
#define ASTEROID_HP_FACTOR 12

static GLKVector4 colors[NUM_ASTEROID_COLORS];

@implementation Asteroid

+(void)initialize {
  int i = 0;
  colors[i++] = GLKVector4Make(0.498, 0.580, 0.690, 1);
  colors[i++] = GLKVector4Make(0.557, 0.686, 0.820, 1);
  colors[i++] = GLKVector4Make(0.631, 0.745, 0.902, 1);
  colors[i++] = GLKVector4Make(0.824, 0.894, 0.988, 1);
}

- (id)init
{
  self = [super init];
  
  if (self) {
    GLKVector4 centralColor = colors[[TERandom randomTo:NUM_ASTEROID_COLORS]];
    self.collide = YES;
    
    for (int i = 0; i < [TERandom randomFrom:2 to:6]; i++) {
      TENode *triangleNode = [[TENode alloc] init];
      
      // Set up shape
      TETriangle *triangleShape = [[TETriangle alloc] init];
      triangleShape.vertices[0] = GLKVector2Make(0, [TERandom randomFractionFrom:0.5 to:1.5]);
      triangleShape.vertices[1] = GLKVector2Make([TERandom randomFractionFrom:-1.5 to:-0.5], 0);
      triangleShape.vertices[2] = GLKVector2Make([TERandom randomFractionFrom:0.5 to:1.5], 0);
      
      triangleShape.renderStyle = kTERenderStyleVertexColors;
      triangleShape.colorVertices[0] = centralColor;
      triangleShape.colorVertices[1] = colors[[TERandom randomTo:NUM_ASTEROID_COLORS]];
      triangleShape.colorVertices[2] = centralColor;
      
      
      triangleShape.node = triangleNode;
      
      // Set up node
      triangleNode.drawable = triangleShape;
      triangleNode.parent = self;
      triangleNode.rotation = [TERandom randomFraction]*M_TAU;
      triangleNode.collide = YES;
      
      [self.children addObject:triangleNode];
    }
    
    self.scale = [TERandom randomFractionFrom:0.25 to:1.25];
    self.angularVelocity = [TERandom randomFraction]*M_TAU;
    self.velocity = GLKVector2Make(0, [TERandom randomFractionFrom:-3.0 to:-1.0]);
    
    hitPoints = self.scale * ASTEROID_HP_FACTOR;
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self removeOutOfScene:scene buffer:2.0];
}

-(void)onRemovalFromScene:(TEScene *)scene {
  [((AsteroidField *)scene).asteroids removeObject:self];
}

-(void)registerHit {
  [[TESoundManager sharedManager] play:@"hurt"];
  
  TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
  highlight.color = GLKVector4Make(1, 1, 1, 1);
  highlight.duration = 0.1;
  [self traverseUsingBlock:^(TENode *node){
    [node.currentAnimations addObject:highlight];
  }];
  
  hitPoints--;
  if ([self dead])
    [self die];
}

-(void)die {
  [self traverseUsingBlock:^(TENode *node){
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
  }];
  
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 0.0;
  scaleAnimation.duration = 0.5;
  scaleAnimation.onRemoval= ^(){
    self.remove = YES;
  };
  [self.currentAnimations addObject:scaleAnimation];
}

-(BOOL)dead {
  return hitPoints <= 0;
}

@end
