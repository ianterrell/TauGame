//
//  TEAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "TENode.h"

typedef enum {
  TEAnimationEasingLinear,
} TEAnimationEasingType;

#define TEAnimationRepeatForever -1

@interface TEAnimation : NSObject {
  TENode *node;
  TEAnimationEasingType easing;
  double elapsedTime, duration;
  int repeat;
  BOOL remove;
}

@property(strong) TENode *node;
@property TEAnimationEasingType easing;
@property double elapsedTime, duration;
@property int repeat;
@property BOOL remove;

@property(readonly) float percentDone;
@property(readonly) float easingFactor;

-(id)initWithNode:(TENode *)_node;

-(void)incrementElapsedTime:(double)time;

@end
