//
//  StarfieldLayer.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "StarfieldLayer.h"

@implementation StarfieldLayer

@synthesize numStars, layerVelocity;

- (id)init
{
  self = [super init];
  if (self) {
    numStars = 50;
    layerVelocity = 1;
    drawable = [[StarfieldLayerShape alloc] init];
    drawable.node = self;
  }
  
  return self;
}

-(void)setVertices {
  self.shape.vertices[0] = GLKVector2Make(width, height);
  self.shape.vertices[1] = GLKVector2Make(    0, height);
  self.shape.vertices[2] = GLKVector2Make(width, 0);
  self.shape.vertices[3] = GLKVector2Make(    0, 0);
  self.shape.vertices[4] = GLKVector2Make(width, 0);
  self.shape.vertices[5] = GLKVector2Make(    0, 0);
  self.shape.vertices[6] = GLKVector2Make(width, 0);
  self.shape.vertices[7] = GLKVector2Make(    0, 0);
}

-(float)width {
  return width;
}

-(void)setWidth:(float)_width {
  width = _width;
  [self setVertices];
}

-(float)height {
  return height;
}

-(void)setHeight:(float)_height {
  height = _height;
  [self setVertices];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];

  float yDiff = layerVelocity * dt;
  float currentY = self.shape.vertices[2].y;
  float newY = currentY - yDiff;
  if (newY < 0)
    newY += height;
  
  self.shape.vertices[2] = self.shape.vertices[4] = GLKVector2Make(width, newY);
  self.shape.vertices[3] = self.shape.vertices[5] = GLKVector2Make(    0, newY);
  
  float texturePortion = 1 - newY / height;
  
  self.shape.textureCoordinates[0] = self.shape.textureCoordinates[6] = GLKVector2Make(1, texturePortion);
  self.shape.textureCoordinates[1] = self.shape.textureCoordinates[7] = GLKVector2Make(0, texturePortion);
}

@end

@implementation StarfieldLayerShape

- (id)init
{
  self = [super initWithVertices:8];
  if (self) {
    NSError *error;
    GLKTextureInfo *texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"main-menu-background.jpg"].CGImage options:nil error:&error];
    if (error) {
      NSLog(@"Error making texture: %@",error);
    }
    
    self.renderStyle = kTERenderStyleTexture;
    effect = [[GLKBaseEffect alloc] init];
    effect.texturingEnabled = YES;
    effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    effect.texture2d0.target = GLKTextureTarget2D;
    effect.texture2d0.glName = texture.glName;
    
    self.textureCoordinates[0] = GLKVector2Make(1, 1);
    self.textureCoordinates[1] = GLKVector2Make(0, 1);
    self.textureCoordinates[2] = GLKVector2Make(1, 0);
    self.textureCoordinates[3] = GLKVector2Make(0, 0);
    self.textureCoordinates[4] = GLKVector2Make(1, 1);
    self.textureCoordinates[5] = GLKVector2Make(0, 1);
    self.textureCoordinates[6] = GLKVector2Make(1, 0);
    self.textureCoordinates[7] = GLKVector2Make(0, 0);
  }
  
  return self;
}

-(GLenum)renderMode {
  return GL_TRIANGLE_STRIP;
}

@end
