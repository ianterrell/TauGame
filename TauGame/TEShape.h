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
  kTERenderStyleTexture
} TERenderStyle;

@interface TEShape : TEDrawable {
  GLKBaseEffect *effect;
  TERenderStyle renderStyle;
  GLKVector4 color;
}

@property(strong, nonatomic) GLKBaseEffect *effect;
@property TERenderStyle renderStyle;
@property GLKVector4 color;
@property(readonly) float radius;

-(void)updateVertices;
-(BOOL)isPolygon;
-(BOOL)isCircle;

@end
