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
    TERandomPolygon *polygon = [[TERandomPolygon alloc] initWithSides:[TERandom randomFrom:5 to:9] lowerFactor:0.5 upperFactor:1.5];
    for (int i = 0; i < polygon.numSides+2; i++)
      polygon.colorVertices[i] = colors[[TERandom randomTo:NUM_ASTEROID_COLORS]];
    polygon.renderStyle = kTERenderStyleVertexColors;
    polygon.node = self;
    
    for (int i = 0; i < polygon.numSides; i++) {
      TENode *triangleNode = [[TENode alloc] init];
      
      // Set up shape
      TETriangle *triangleShape = [[TETriangle alloc] init];
      triangleShape.vertices[0] = polygon.vertices[0];
      triangleShape.vertices[1] = polygon.vertices[i+1];
      triangleShape.vertices[2] = polygon.vertices[i+2 > polygon.numSides ? 1 : i+2];
      
      triangleShape.renderStyle = kTERenderStyleNone;
      triangleShape.colorVertices[0] = polygon.colorVertices[0];
      triangleShape.colorVertices[1] = polygon.colorVertices[i+1];
      triangleShape.colorVertices[2] = polygon.colorVertices[i+2 > polygon.numSides ? 1 : i+2];
      
      triangleShape.node = triangleNode;
      triangleNode.drawable = triangleShape;
      
      [self addChild:triangleNode];
    }

    self.drawable = polygon;
    self.angularVelocity = [TERandom randomFractionFrom:-1 to:1]*M_TAU;
    self.velocity = GLKVector2Make(0, [TERandom randomFractionFrom:-3.0 to:-1.0]);
    
    hitPoints = self.scale * ASTEROIDS_HP_PER_SCALE_INITIAL;
  }
  
  return self;
}

-(void)setupInGame:(Game*)game {
  [game.characters insertObject:self atIndex:3];
  [game.enemies addObject:self];
  [game.enemyBullets addObject:self];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self removeOutOfScene:scene buffer:2.0];
}

-(void)explode {
  __block BOOL setRemovedCallback = NO;
  [self traverseUsingBlock:^(TENode *node){
    if (node != self) {
      node.shape.renderStyle = kTERenderStyleVertexColors;
      TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
      rotateAnimation.rotation = [TERandom randomFractionFrom:-2 to:2] * M_TAU;
      rotateAnimation.duration = 0.5;
      [node.currentAnimations addObject:rotateAnimation];
      
      TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
      translateAnimation.translation = GLKVector2Make([TERandom randomFractionFrom:-2 to:2], [TERandom randomFractionFrom:-2 to:2]);
      translateAnimation.duration = 0.5;
      [node.currentAnimations addObject:translateAnimation];
      
      TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
      scaleAnimation.scale = 0.0;
      scaleAnimation.duration = 0.5;
      if (!setRemovedCallback) {
        scaleAnimation.onRemoval= ^(){
          self.remove = YES;
        };
        setRemovedCallback = YES;
      }
      [node startAnimation:scaleAnimation];
    }
  }];
  
  self.collide = NO;
  self.shape.renderStyle = kTERenderStyleNone;
  self.angularVelocity = 0;
  self.velocity = GLKVector2Make(0,0);
}

@end
