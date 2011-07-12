//
//  TEEllipse.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "TEShape.h"

@interface TEEllipse : TEShape {
  GLfloat radiusX, radiusY;
  GLfloat vertices[2*TE_ELLIPSE_NUM_VERTICES];
}

@property GLfloat radiusX, radiusY;

@end
