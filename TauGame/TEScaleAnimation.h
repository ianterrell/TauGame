//
//  TEScaleAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@interface TEScaleAnimation : TEAnimation {
  float scale;
}

@property float scale;
@property(readonly) float easedScale;

@end
