//
//  TEShape.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"

@class TENode;

@interface TEShape : TEDrawable {
  GLKVector4 color;
}

@property GLKVector4 color;

-(void)renderInScene:(TEScene *)scene forNode:(TENode *)node;

-(void)updateVertices;

-(BOOL)isPolygon;
-(BOOL)isCircle;

@end
