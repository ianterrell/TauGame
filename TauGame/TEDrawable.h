//
//  TEDrawable.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "TEScene.h"

@interface TEDrawable : NSObject {
  GLKBaseEffect *effect;
  GLKVector2 translation;
  GLfloat scale;
  GLfloat rotation;
}

@property(strong, nonatomic) GLKBaseEffect *effect;
@property GLKVector2 translation;
@property GLfloat scale;
@property GLfloat rotation;

-(void)renderInScene:(TEScene *)scene;
-(GLKMatrix4)modelViewMatrix;

@end
