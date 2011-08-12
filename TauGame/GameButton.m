//
//  GameButton.m
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "GameButton.h"
#import "TauEngine.h"

static GLKBaseEffect *glowingEffect;

#define GLOW_SIZE_FACTOR 2
#define HIGHLIGHT_SCALE 1.1
#define HIGHLIGHT_DURATION 0.08

@implementation GameButton

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


-(id) initWithText:(NSString *)text {
  self = [super init];
  if (self) {
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:64];
    TESprite *sprite = [[TESprite alloc] initWithImage:[TEImage imageFromText:text withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
    self.drawable = sprite;
    self.collide = YES;
    self.scaleX = 0.75;
    self.scaleY = 0.375;
    
    // Set up glow
    
    self.renderChildrenFirst = YES;
    glowNode = [[TENode alloc] init];
    
    TERectangle *rectangle = [[TERectangle alloc] init];
    rectangle.node = glowNode;
    rectangle.height = ((TESprite*)self.shape).height * 2;
    rectangle.width = ((TESprite*)self.shape).width * 3;
    glowNode.drawable = rectangle;
    
    rectangle.renderStyle = kTERenderStyleNone;
    rectangle.color = GLKVector4Make(0.5,0.99,1,1);
    rectangle.effect = glowingEffect;
    
    rectangle.textureCoordinates[0] = GLKVector2Make(0, 1);
    rectangle.textureCoordinates[1] = GLKVector2Make(1, 1);
    rectangle.textureCoordinates[2] = GLKVector2Make(1, 0);
    rectangle.textureCoordinates[3] = GLKVector2Make(0, 0);
    
    [self addChild:glowNode];
  }
  return self;
}

-(void)highlight {
  glowNode.shape.renderStyle = kTERenderStyleConstantColor | kTERenderStyleTexture;
  
  TEScaleAnimation *animation = [[TEScaleAnimation alloc] initWithNode:self];
  animation.scale = HIGHLIGHT_SCALE;
  animation.duration = HIGHLIGHT_DURATION;
  animation.permanent = YES;
  [self startAnimation:animation];
}

-(void)unhighlight {
  glowNode.shape.renderStyle = kTERenderStyleNone;
  
  TEScaleAnimation *animation = [[TEScaleAnimation alloc] initWithNode:self];
  animation.scale = 1.0/HIGHLIGHT_SCALE;
  animation.duration = HIGHLIGHT_DURATION;
  animation.permanent = YES;

  [self startAnimation:animation];
}

-(void)fire {
  TEScaleAnimation *animation = [[TEScaleAnimation alloc] initWithNode:self];
  animation.duration = HIGHLIGHT_DURATION;
  animation.onRemoval = ^(){
    [super fire];
  };
  [self startAnimation:animation];
}

@end
