//
//  TEShape.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"
#import "TEEllipse.h"

static GLKBaseEffect *defaultEffect;
static GLKBaseEffect *constantColorEffect;

@implementation TEShape

@synthesize effect, renderStyle, color;

+(void)initialize {
  defaultEffect = [[GLKBaseEffect alloc] init];
  
  constantColorEffect = [[GLKBaseEffect alloc] init];
  constantColorEffect.useConstantColor = YES;
}

- (id)init
{
  self = [super init];
  if (self) {
    renderStyle = kTERenderStyleConstantColor;
  }
  
  return self;
}

-(int)numVertices {
  return 0;
}

- (GLKVector2 *)vertices {
  if (vertexData == nil) {
    vertexData = [NSMutableData dataWithLength:sizeof(GLKVector2)*self.numVertices];
    vertices = [vertexData mutableBytes];
  }
  return vertices;
}

-(GLKVector2 *)textureCoordinates {
  if (textureData == nil) {
    textureData = [NSMutableData dataWithLength:sizeof(GLKVector2)*self.numVertices];
    textureCoordinates = [textureData mutableBytes];
  }
  return textureCoordinates;
}

-(GLKVector4 *)colorVertices {
  if (colorData == nil) {
    colorData = [NSMutableData dataWithLength:sizeof(GLKVector4)*self.numVertices];
    colorVertices = [colorData mutableBytes];
  }
  return colorVertices;
}

-(void)updateVertices {
}

-(GLenum)renderMode {
  return GL_TRIANGLE_FAN;
}

-(void)renderInScene:(TEScene *)scene {
  // Initialize the effect if necessary
  if (effect == nil) {
    switch (renderStyle) {
      case kTERenderStyleConstantColor:
        effect = constantColorEffect;
        break;
      case kTERenderStyleVertexColors:
        effect = defaultEffect;
        break;
      default:
        break;
    }
  }
  
  effect.transform.modelviewMatrix = [node modelViewMatrix];
  effect.transform.projectionMatrix = [scene projectionMatrix];
  
  // Set up effect specifics
  if (renderStyle == kTERenderStyleConstantColor) {
    effect.constantColor = color;
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
      if ([animation isKindOfClass:[TEColorAnimation class]]) {
        TEColorAnimation *colorAnimation = (TEColorAnimation *)animation;
        effect.constantColor = GLKVector4Add(self.effect.constantColor, colorAnimation.easedColor);
      }
    }];
  }
  
  // Finalize effect
  [effect prepareToDraw];
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  
  if (renderStyle == kTERenderStyleVertexColors) {
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colorVertices);
  } else if (renderStyle == kTERenderStyleTexture) {
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureCoordinates);
  }
  
  glDrawArrays(self.renderMode, 0, self.numVertices);
  
  glDisableVertexAttribArray(GLKVertexAttribPosition);
  
  if (renderStyle == kTERenderStyleVertexColors)
    glDisableVertexAttribArray(GLKVertexAttribColor);
  else if (renderStyle == kTERenderStyleTexture)
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

-(BOOL)isPolygon {
  return ![self isCircle];
}

-(BOOL)isCircle {
  return [self isKindOfClass:[TEEllipse class]];
}

-(float)radius {
  return 0.0;
}

@end
