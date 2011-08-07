//
//  GlowingBullet.m
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GlowingBullet.h"
#import "TauEngine.h"

static GLKBaseEffect *glowingEffect;

@implementation GlowingBullet

+(void)initialize {
  UIImage *glowImage = [UIImage imageNamed:@"glow.png"];
  
  NSError *error;
  GLKTextureInfo *texture = [GLKTextureLoader textureWithCGImage:glowImage.CGImage options:nil error:&error];
  if (error) {
    NSLog(@"Error making texture: %@", error);
  }
  
  glowingEffect = [[GLKBaseEffect alloc] init];
  glowingEffect.texturingEnabled = YES;
  glowingEffect.texture2d0.envMode = GLKTextureEnvModeModulate;
  glowingEffect.texture2d0.target = GLKTextureTarget2D;
  glowingEffect.texture2d0.glName = texture.glName;
}

-(id)initWithColor:(GLKVector4)color
{
  self = [super initWithColor:color];
  if (self) {
    self.renderChildrenFirst = YES;
    TENode *glowNode = [[TENode alloc] init];
    
    TERectangle *rectangle = [[TERectangle alloc] init];
    rectangle.node = glowNode;
    rectangle.height = 1;//0.2;
    rectangle.width = 0.7;//0.14;
    glowNode.drawable = rectangle;
    
    rectangle.renderStyle = kTERenderStyleConstantColor | kTERenderStyleTexture;
    rectangle.color = self.shape.color;
    rectangle.effect = glowingEffect;
    
    rectangle.textureCoordinates[0] = GLKVector2Make(0, 1);
    rectangle.textureCoordinates[1] = GLKVector2Make(1, 1);
    rectangle.textureCoordinates[2] = GLKVector2Make(1, 0);
    rectangle.textureCoordinates[3] = GLKVector2Make(0, 0);
    
    [self addChild:glowNode];
  }
  
  return self;
}

@end
