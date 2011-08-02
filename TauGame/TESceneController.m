//
//  TESceneController.m
//  TauGame
//
//  Created by Ian Terrell on 7/18/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TESceneController.h"

@implementation TESceneController

@synthesize context, currentScene, scenes;

- (id)init
{
  self = [super init];
  if (self) {
    // OPTIMIZATION: configurable initWithCapacity, configurable FPS
    scenes = [[NSMutableDictionary alloc] init];
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    self.preferredFramesPerSecond = 60;
  }
  
  return self;
}


# pragma mark The Controller

+(TESceneController *)sharedController {
  static TESceneController *singleton;
  
  @synchronized(self) {
    if (!singleton)
      singleton = [[TESceneController alloc] init];
    return singleton;
  }
}

# pragma mark Scene Management

-(void)addScene:(TEScene *)scene named:(NSString *)name {
  scene.context = context;
  [scenes setObject:scene forKey:name];
}

-(void)displayScene:(NSString *)name {
  currentScene = [scenes objectForKey:name];
  [currentScene orientationChangedTo:self.interfaceOrientation];
  self.delegate = currentScene;
  self.view = currentScene;
}

# pragma mark Device Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  NSLog(@"shouldautorotate to %d", toInterfaceOrientation);
  return [currentScene orientationSupported:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  NSLog(@"will autorotate to %d", toInterfaceOrientation);
  self.paused = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  NSLog(@"did autorotate from %d", fromInterfaceOrientation);
  [currentScene orientationChangedTo:self.interfaceOrientation];
  self.paused = NO;
}

@end
