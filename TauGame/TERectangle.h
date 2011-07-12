//
//  TERectangle.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"

@interface TERectangle : TEShape {
  GLfloat height, width;
  GLfloat vertices[8];
}

@property GLfloat height, width;

@end
