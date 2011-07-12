//
//  TEAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TauEngine.h"

typedef enum {
  TEAnimationScale,
  TEAnimationRotate,
  TEAnimationTranslate
} TEAnimationType;

typedef enum {
  TEAnimationEasingLinear,
} TEAnimationEasingType;

#define TEAnimationRepeatForever -1

@interface TEAnimation : NSObject {
  TEAnimationType type;
  TEAnimationEasingType easing;
  GLfloat value0, value1;
  double elapsedTime, duration;
  int repeat;
}

@property TEAnimationType type;
@property TEAnimationEasingType easing;
@property GLfloat value0, value1;
@property double elapsedTime, duration;
@property int repeat;

-(GLKMatrix4)modelViewMatrix;

@end
