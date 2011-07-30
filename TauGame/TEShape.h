//
//  TEShape.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"

typedef enum {
  kTERenderStyleConstantColor,
  kTERenderStyleVertexColors,
  kTERenderStyleTexture,
  kTERenderStyleNone
} TERenderStyle;

@interface TEShape : TEDrawable {
  GLKBaseEffect *effect;
  TERenderStyle renderStyle;
  GLKVector4 color;
  
  NSMutableData *vertexData, *textureData, *colorData;
  GLKVector2 *vertices, *textureCoordinates;
  GLKVector4 *colorVertices;
}

@property(strong, nonatomic) GLKBaseEffect *effect;
@property TERenderStyle renderStyle;
@property GLKVector4 color;

@property(readonly) int numVertices;
@property(readonly) GLKVector2 *vertices;
@property(readonly) GLKVector2 *textureCoordinates;
@property(readonly) GLKVector4 *colorVertices;

@property(readonly) float radius; // for bounding circle collision detection

@property(readonly) GLenum renderMode;

-(void)updateVertices;
-(BOOL)isPolygon;
-(BOOL)isCircle;

@end
