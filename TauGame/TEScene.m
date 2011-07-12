//
//  TEScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"

@implementation TEScene

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

-(void)render {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self render];
}

@end
