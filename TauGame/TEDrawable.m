//
//  TEDrawable.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"

@implementation TEDrawable

@synthesize parent, effect, translation, scale, rotation, currentAnimations;

- (id)init
{
  self = [super init];
  if (self) {
    self.scale = 1.0;
    self.rotation = 0.0;
    self.translation = GLKVector2Make(0.0, 0.0);
    self.currentAnimations = [[NSMutableArray alloc] init];
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  self.effect = [scene constantColorEffect];
  self.effect.transform.modelviewMatrix = [self modelViewMatrix];
  self.effect.transform.projectionMatrix = [scene projectionMatrix];
}

-(GLKMatrix4)modelViewMatrix {
  __block GLKMatrix4 mvMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(translation.x, translation.y, 0.0),GLKMatrix4MakeScale(scale, scale, 1.0));
  mvMatrix = GLKMatrix4Multiply(mvMatrix, GLKMatrix4MakeZRotation(rotation));
  [currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
    // Undo the translation, then reapply it after animating to ensure rotations happen around the centerpoint.
    // It might make more sense (or be much more performant for large scenes) to store different types of translations separately; maybe a queue or stack per scaling, rotation, translation; that include all object and animation translations
    mvMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(-translation.x, -translation.y, 0.0), mvMatrix);
    mvMatrix = GLKMatrix4Multiply([animation modelViewMatrix], mvMatrix);
    mvMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(translation.x, translation.y, 0.0), mvMatrix);
  }];
  if (parent)
    mvMatrix = GLKMatrix4Multiply([self.parent modelViewMatrix], mvMatrix);
  return mvMatrix;
}

@end
