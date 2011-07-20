//
//  TEScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TEScene : GLKView <GLKViewDelegate, GLKViewControllerDelegate> {
  GLfloat left, right, bottom, top;
  GLKVector4 clearColor;
  GLKBaseEffect *constantColorEffect;
  NSMutableArray *characters;
  
  UIDeviceOrientation currentOrientation;
  GLKMatrix4 orientationRotationMatrix;
}

@property GLfloat left, right, bottom, top;
@property(readonly) float width, height;
@property GLKVector4 clearColor;
@property(strong, nonatomic) NSMutableArray *characters;
@property(readonly) GLKBaseEffect *constantColorEffect;
@property UIDeviceOrientation currentOrientation;
@property GLKMatrix4 orientationRotationMatrix;

# pragma mark Scene Setup

-(void)setLeft:(GLfloat)left right:(GLfloat)right bottom:(GLfloat)bottom top:(GLfloat)top;
-(GLKVector2)bottomLeftVisible;
-(GLKVector2)topRightVisible;

# pragma mark Orientation

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation;
-(void)orientationChangedTo:(UIDeviceOrientation)orientation;
-(float)turnsForOrientation;
-(float)orientationOffset;

# pragma mark Rendering

-(void)render;
-(GLKMatrix4)projectionMatrix;

@end
