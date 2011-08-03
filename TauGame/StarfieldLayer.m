//
//  StarfieldLayer.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "StarfieldLayer.h"

@implementation StarfieldLayer

@synthesize layerVelocity;

-(id)initWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio numStars:(int)numStars
{
  self = [super init];
  if (self) {
    width = _width;
    height = _height;
    
    layerVelocity = 1;
    
    UIImage *starfieldImage = [StarfieldLayer starfieldImageWithStars:numStars width:(int)(pixelRatio * width) height:(int)(pixelRatio * height)];
    
    drawable = [[StarfieldLayerShape alloc] initWithWidth:width height:height textureImage:starfieldImage];
    drawable.node = self;
    
    TEVertexColorAnimation *highlight = [[TEVertexColorAnimation alloc] initWithNode:self];
    for (int i = 0; i < self.shape.numVertices; i++)
      highlight.toColorVertices[i] = GLKVector4Make([TERandom randomFractionFrom:0.7 to:1.0], [TERandom randomFractionFrom:0.7 to:1.0], [TERandom randomFractionFrom:0.7 to:1.0], 1);
    highlight.duration = 5;
    highlight.reverse = YES;
    highlight.repeat = TEAnimationRepeatForever;
    [self.currentAnimations addObject:highlight];
  }
  
  return self;
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

+(UIImage *)starfieldImageWithStars:(int)num width:(int)width height:(int)height {
  float scale = [UIScreen mainScreen].scale;
  width *= scale;
  height *= scale;
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef contextRef =  CGBitmapContextCreate (NULL,
                                                    width, height,
                                                    8, 4*width,
                                                    colorSpace,
                                                    /* kCGBitmapByteOrder32Host for after beta5 */ kCGImageAlphaPremultipliedFirst
                                                    );
  CGColorSpaceRelease(colorSpace);
  UIGraphicsPushContext(contextRef);
  
  CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
  for (int i = 0; i < num; i++) {
    int radius = [TERandom randomTo:3] * scale;
    CGContextFillEllipseInRect(contextRef, CGRectMake([TERandom randomTo:width], [TERandom randomTo:height], radius, radius));
  }
  
  UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(contextRef) scale:1.0 orientation:UIImageOrientationDownMirrored];
  
  UIGraphicsPopContext();
  
  return image;
}


@end

@implementation StarfieldLayerShape

-(id)initWithWidth:(float)width height:(float)height textureImage:(UIImage *)image
{
  self = [super initWithVertices:8];
  if (self) {
    NSError *error;
    GLKTextureInfo *texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
    if (error) {
      NSLog(@"Error making texture: %@",error);
    }
    
    self.renderStyle = kTERenderStyleTexture | kTERenderStyleVertexColors;
    effect = [[GLKBaseEffect alloc] init];
    effect.texturingEnabled = YES;
    effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    effect.texture2d0.target = GLKTextureTarget2D;
    effect.texture2d0.glName = texture.glName;
    
    
    self.vertices[0] = GLKVector2Make(width, height);
    self.vertices[1] = GLKVector2Make(    0, height);
    self.vertices[2] = GLKVector2Make(width, 0);
    self.vertices[3] = GLKVector2Make(    0, 0);
    self.vertices[4] = GLKVector2Make(width, 0);
    self.vertices[5] = GLKVector2Make(    0, 0);
    self.vertices[6] = GLKVector2Make(width, 0);
    self.vertices[7] = GLKVector2Make(    0, 0);
    
    self.textureCoordinates[0] = GLKVector2Make(1, 1);
    self.textureCoordinates[1] = GLKVector2Make(0, 1);
    self.textureCoordinates[2] = GLKVector2Make(1, 0);
    self.textureCoordinates[3] = GLKVector2Make(0, 0);
    self.textureCoordinates[4] = GLKVector2Make(1, 1);
    self.textureCoordinates[5] = GLKVector2Make(0, 1);
    self.textureCoordinates[6] = GLKVector2Make(1, 0);
    self.textureCoordinates[7] = GLKVector2Make(0, 0);
    
    for (int i = 0; i < self.numVertices; i++)
      self.colorVertices[i] = GLKVector4Make([TERandom randomFractionFrom:0.7 to:1.0], [TERandom randomFractionFrom:0.7 to:1.0], [TERandom randomFractionFrom:0.7 to:1.0], 1);
  }
  
  return self;
}

-(GLenum)renderMode {
  return GL_TRIANGLE_STRIP;
}


@end
