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
  TEDrawable *parent;
  GLKBaseEffect *effect;
  GLKVector2 position;
  GLfloat scale;
  GLfloat rotation;
  NSMutableArray *currentAnimations;

  GLKMatrix4 cachedModelViewMatrix;
  BOOL dirtyModelViewMatrix;
}

@property(strong, nonatomic) TEDrawable *parent;
@property(strong, nonatomic) GLKBaseEffect *effect;
@property GLKVector2 position;
@property GLfloat scale;
@property GLfloat rotation;
@property(strong, nonatomic) NSMutableArray *currentAnimations;
@property BOOL dirtyModelViewMatrix;

-(void)renderInScene:(TEScene *)scene;
-(GLKMatrix4)modelViewMatrix;

// TODO: should parents be TENodes? Node-Shape smell here again
-(void)crawlUpWithBlock:(void (^)(TEDrawable *))block;

@end
