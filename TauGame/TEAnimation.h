//
//  TEAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  TEAnimationEasingLinear,
} TEAnimationEasingType;

#define TEAnimationRepeatForever -1

@interface TEAnimation : NSObject {
  TEAnimationEasingType easing;
  double elapsedTime, duration;
  int repeat;
  BOOL remove;
}

@property TEAnimationEasingType easing;
@property double elapsedTime, duration;
@property int repeat;
@property BOOL remove;

@property(readonly) float percentDone;
@property(readonly) float easingFactor;

-(void)incrementElapsedTime:(double)time;

@end
