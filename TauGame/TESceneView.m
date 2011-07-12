//
//  TESceneView.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TESceneView.h"

@implementation TESceneView

@synthesize scene;

-(void)setupNewScene {
  self.scene = [[TEScene alloc] init];
  self.delegate = self.scene;
}

- (id)init {
  self = [super init];
  if (self) {
    [self setupNewScene];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupNewScene];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)context {
  self = [super initWithFrame:frame context:context];
  if (self) {
    [self setupNewScene];
  }
  
  return self;
}

@end
