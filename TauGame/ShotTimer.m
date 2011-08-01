//
//  ShotTimer.m
//  TauGame
//
//  Created by Ian Terrell on 8/1/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "ShotTimer.h"

@implementation ShotTimer

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"shot-timer"];
    bar = [self childNamed:@"bar"];
  }
  
  return self;
}

-(BOOL)ready {
  return bar.scaleX == 0.0;
}

-(void)fireWithTime:(float)time {
  bar.scaleX = 1.0;
  
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scaleX = 0.0;
  scaleAnimation.duration = time;  
  scaleAnimation.onRemoval= ^(){
    bar.scaleX = 0.0;
  };
  [bar.currentAnimations addObject:scaleAnimation];
  
  TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
  translateAnimation.translation = GLKVector2Make(-5.0,0);
  translateAnimation.duration = time;
  [bar.currentAnimations addObject:translateAnimation];
  
  [bar markModelViewMatrixDirty];
//  [self markModelViewMatrixDirty];
}

@end
