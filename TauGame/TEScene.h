//
//  TEScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TEScene : NSObject <GLKViewDelegate, GLKViewControllerDelegate> {
  GLfloat left, right, bottom, top;
  GLKVector4 clearColor;
  GLKBaseEffect *constantColorEffect;
  NSMutableArray *characters;
}

@property GLfloat left, right, bottom, top;
@property GLKVector4 clearColor;
@property(strong, nonatomic) NSMutableArray *characters;
@property(readonly) GLKBaseEffect *constantColorEffect;

# pragma mark Scene Setup

-(void)setLeft:(GLfloat)left right:(GLfloat)right bottom:(GLfloat)bottom top:(GLfloat)top;

# pragma mark Rendering

-(void)render;
-(GLKMatrix4)projectionMatrix;

@end
