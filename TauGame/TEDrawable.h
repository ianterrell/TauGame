//
//  TEDrawable.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class TENode;
@class TEScene;

typedef enum {
  kTERenderStyleConstantColor,
  kTERenderStyleVertexColors,
  kTERenderStyleTexture
} TERenderStyle;

@interface TEDrawable : NSObject {
  TENode *node;
  GLKBaseEffect *effect;
  TERenderStyle renderStyle;
  GLKVector4 color;
}

@property(strong, nonatomic) TENode *node;
@property(strong, nonatomic) GLKBaseEffect *effect;

@property TERenderStyle renderStyle;
@property GLKVector4 color;

-(void)renderInScene:(TEScene *)scene;

@end
