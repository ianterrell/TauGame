//
//  Starfield.m
//  TauGame
//
//  Created by Ian Terrell on 7/29/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Starfield.h"

#define NUM_STARS 200
#define LAYERS 5
#define LAYER_RATIO 0.6
#define VELOCITY 1
#define VELOCITY_RATIO 0.65

@implementation Starfield

- (id)initInScene:(TEScene *)scene
{
  self = [super init];
  if (self) {
    StarfieldShape *starfieldShape = [[StarfieldShape alloc] init];
    starfieldShape.width = scene.topRightVisible.x - scene.bottomLeftVisible.x;
    starfieldShape.height = scene.topRightVisible.y - scene.bottomLeftVisible.y;
    [starfieldShape initVertices];
    starfieldShape.node = self;

    self.drawable = starfieldShape;
    self.position = scene.bottomLeftVisible;
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [(StarfieldShape *)drawable updateStarPositions:dt];
}

@end

@implementation StarfieldShape

@synthesize width, height;

- (id)init
{
  self = [super init];
  if (self) {
    renderStyle = kTERenderStyleConstantColor;
    color = GLKVector4Make(1,1,1,1);
  }
  
  return self;
}

-(GLenum)renderMode {
  return GL_POINTS;
}

-(int)numVertices {
  return NUM_STARS;
}

-(void)initVertices {
  for (int i = 0; i < self.numVertices; i++) {
    self.vertices[i] = GLKVector2Make([TERandom randomFraction]*width, [TERandom randomFraction]*height);
  }
}

-(int)layerForIndex:(int)index {
  int starsCount = 0;
  for (int layer = 0; layer < LAYERS; layer++) {
    starsCount += LAYER_RATIO * (NUM_STARS-starsCount);
    if (index < starsCount)
      return LAYERS - layer;
  }
  return 0;
}

-(void)updateStarPositions:(NSTimeInterval)dt {
  for (int i = 0; i < self.numVertices; i++) {
    float velocity = VELOCITY;
    for (int layer = 0; layer < [self layerForIndex:i]; layer++)
      velocity *= VELOCITY_RATIO;
    
    float x = self.vertices[i].x;
    float y = self.vertices[i].y - velocity*dt;
    if (y < 0)
      y += height;
    
    self.vertices[i] = GLKVector2Make(x, y);
  }
}

@end
