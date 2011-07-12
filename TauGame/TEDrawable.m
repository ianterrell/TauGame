//
//  TEDrawable.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"

@implementation TEDrawable

@synthesize parent, effect, translation, scale, rotation;

- (id)init
{
  self = [super init];
  if (self) {
    self.scale = 1.0;
    self.rotation = 0.0;
    self.translation = GLKVector2Make(0.0, 0.0);
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  NSLog(@"%@ renderInScene", self);
  self.effect = [scene constantColorEffect];
  self.effect.transform.modelviewMatrix = [self modelViewMatrix];
  self.effect.transform.projectionMatrix = [scene projectionMatrix];
}

-(GLKMatrix4)modelViewMatrix {
  GLKMatrix4 mvMatrix = GLKMatrix4Multiply(GLKMatrix4MakeScale(scale, scale, 1.0), GLKMatrix4MakeTranslation(translation.x, translation.y, 0.0));
  mvMatrix = GLKMatrix4Multiply(mvMatrix, GLKMatrix4MakeZRotation(rotation));
  if (parent)
    mvMatrix = GLKMatrix4Multiply([self.parent modelViewMatrix], mvMatrix);
  return mvMatrix;
}

@end
