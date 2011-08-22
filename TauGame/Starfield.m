//
//  StarfieldLayer.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Starfield.h"

#define NUM_STAR_COLORS 7
static GLKVector4 colors[NUM_STAR_COLORS];

@implementation Starfield

+(void)initialize {
  int i = 0;
  colors[i++] = GLKVector4Make(0.345, 0.776, 0.984, 1); // bluish
  colors[i++] = GLKVector4Make(0.937, 0.784, 0.718, 1); // pinkish
  colors[i++] = GLKVector4Make(0.933, 1.000, 1.000, 1); // light light bluish
  colors[i++] = GLKVector4Make(1.000, 0.988, 0.788, 1); // yellowish
  colors[i++] = GLKVector4Make(0.365, 0.541, 1.000, 1); // blue
  colors[i++] = GLKVector4Make(1.000, 0.553, 0.227, 1); // orange
  colors[i++] = GLKVector4Make(0.902, 0.973, 0.643, 1); // yellow
}

+(void)addDefaultStarfieldWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio toScene:(TEScene *)scene {
  Starfield *starfield = [Starfield defaultStarfieldWithWidth:_width height:_height pixelRatio:pixelRatio];
  for (TENode *node in [starfield layers])
    [scene.characters addObject:node];
}

+(Starfield *)defaultStarfieldWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio {
  NSMutableDictionary *layer1Desc = [NSMutableDictionary dictionaryWithCapacity:3];
  [layer1Desc setObject:[NSNumber numberWithInt:300] forKey:@"numStars"];
  [layer1Desc setObject:[NSNumber numberWithFloat:1.75] forKey:@"starSize"];
  [layer1Desc setObject:[NSNumber numberWithFloat:0.25] forKey:@"velocity"];
  
  NSMutableDictionary *layer2Desc = [NSMutableDictionary dictionaryWithCapacity:3];
  [layer2Desc setObject:[NSNumber numberWithInt:75] forKey:@"numStars"];
  [layer2Desc setObject:[NSNumber numberWithFloat:2.5] forKey:@"starSize"];
  [layer2Desc setObject:[NSNumber numberWithFloat:0.5] forKey:@"velocity"];
    
  return [[Starfield alloc] initWithWidth:_width height:_height pixelRatio:pixelRatio layers:[NSArray arrayWithObjects:layer1Desc, layer2Desc, nil]];
}

-(id)initWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio layers:(NSArray *)layerDescriptions {
  self = [super init];
  if (self) {
    layers = [NSMutableArray arrayWithCapacity:[layerDescriptions count]];
    for (NSDictionary *description in layerDescriptions) {
      int numStars = [[description objectForKey:@"numStars"] intValue];
      float starSize = [[description objectForKey:@"starSize"] floatValue];
      float velocity = [[description objectForKey:@"velocity"] floatValue];
      StarfieldLayer *layer = [[StarfieldLayer alloc] initWithWidth:_width height:_height pixelRatio:pixelRatio numStars:numStars starSize:starSize velocity:velocity];
      [layers addObject:layer];
    }
  }
  
  return self;
}

-(NSArray *)layers {
  return layers;
}

@end

@implementation StarfieldLayer

@synthesize layerVelocity;

-(id)initWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio numStars:(int)numStars starSize:(float)starSize velocity:(float)_velocity
{
  self = [super init];
  if (self) {
    width = _width;
    height = _height;
    
    layerVelocity = _velocity;
    
    UIImage *starfieldImage = [StarfieldLayer starfieldImageWithStars:numStars width:(int)(pixelRatio * width) height:(int)(pixelRatio * height) starSize:starSize];
    
    drawable = [[StarfieldLayerShape alloc] initWithWidth:width height:height textureImage:starfieldImage];
    drawable.node = self;
    
    TEVertexColorAnimation *highlight = [[TEVertexColorAnimation alloc] initWithNode:self];
    for (int i = 0; i < self.shape.numVertices; i++)
      highlight.toColorVertices[i] = colors[[TERandom randomTo:NUM_STAR_COLORS]];
    highlight.duration = 5;
    highlight.reverse = YES;
    highlight.repeat = kTEAnimationRepeatForever;
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

+(UIImage *)starfieldImageWithStars:(int)num width:(int)width height:(int)height starSize:(float)starSize {
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
    float radius = starSize * scale;
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
    effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    effect.texture2d0.target = GLKTextureTarget2D;
    effect.texture2d0.name = texture.name;
    
    
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
      self.colorVertices[i] = colors[[TERandom randomTo:NUM_STAR_COLORS]];
  }
  
  return self;
}

-(GLenum)renderMode {
  return GL_TRIANGLE_STRIP;
}


@end
