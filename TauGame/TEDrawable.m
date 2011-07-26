//
//  TEDrawable.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"
#import "TauEngine.h"

@implementation TEDrawable

@synthesize parent, effect, currentAnimations, dirtyModelViewMatrix;

- (id)init
{
  self = [super init];
  if (self) {
    scale = 1.0;
    rotation = 0.0;
    position = GLKVector2Make(0.0, 0.0);
    currentAnimations = [[NSMutableArray alloc] init];
    
    dirtyModelViewMatrix = YES;
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  self.effect = [scene constantColorEffect];
  self.effect.transform.modelviewMatrix = [self modelViewMatrix];
  self.effect.transform.projectionMatrix = [scene projectionMatrix];
}

-(GLKMatrix4)modelViewMatrix {
  if (dirtyModelViewMatrix) {
    __block GLKVector2 mvTranslation = position;
    __block GLfloat mvScale = scale;
    __block GLfloat mvRotation = rotation;
    
    [currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
      if ([animation isKindOfClass:[TETranslateAnimation class]])
        mvTranslation = GLKVector2Add(mvTranslation, ((TETranslateAnimation *)animation).easedTranslation);
      else if ([animation isKindOfClass:[TERotateAnimation class]])
        mvRotation += ((TERotateAnimation *)animation).easedRotation;
      else if ([animation isKindOfClass:[TEScaleAnimation class]])
        mvScale *= ((TEScaleAnimation *)animation).easedScale;
    }];

    GLKMatrix4 mvMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(mvTranslation.x, mvTranslation.y, 0.0),GLKMatrix4MakeScale(mvScale, mvScale, 1.0));
    mvMatrix = GLKMatrix4Multiply(mvMatrix, GLKMatrix4MakeZRotation(mvRotation));
    if (parent)
      mvMatrix = GLKMatrix4Multiply([self.parent modelViewMatrix], mvMatrix);
    else { // final orientation rotation
      TEScene *currentScene = [TESceneController sharedController].currentScene;
      if (currentScene != nil)
        mvMatrix = GLKMatrix4Multiply(currentScene.orientationRotationMatrix, mvMatrix);
    }
    
    cachedModelViewMatrix = mvMatrix;
    dirtyModelViewMatrix = NO;
  }
  return cachedModelViewMatrix;
}

-(void)markModelViewMatrixDirty {
  dirtyModelViewMatrix = YES;
}

-(GLKVector2)position {
  return position;
}

-(void)setPosition:(GLKVector2)_position {
  position = _position;
  [self markModelViewMatrixDirty];
}

-(float)scale {
  return scale;
}

-(void)setScale:(float)_scale {
  scale = _scale;
  [self markModelViewMatrixDirty];
}

-(float)rotation {
  return rotation;
}

-(void)setRotation:(float)_rotation {
  rotation = _rotation;
  [self markModelViewMatrixDirty];
}

-(void)crawlUpWithBlock:(void (^)(TEDrawable *))block {
  block(self);
  if (parent != nil)
    [parent crawlUpWithBlock:block];
}


@end
