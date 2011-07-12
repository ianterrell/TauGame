//
//  TETriangle.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"

@interface TETriangle : TEShape {
  GLfloat vertices[6];
}

@property GLKVector2 vertex0, vertex1, vertex2;

@end
