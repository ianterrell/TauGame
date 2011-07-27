//
//  TEPolygon.h
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"

@interface TEPolygon : TEShape {
  NSMutableData *vertexData;
  GLKVector2 *vertices;
  int numVertices;
  float radius;
}

@property(readonly) int numVertices;
@property(readonly) GLKVector2 *vertices;
@property float radius;

- (id)initWithVertices:(int)numVertices;

@end
