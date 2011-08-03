//
//  TESceneController.m
//  TauGame
//
//  Created by Ian Terrell on 7/18/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TESceneController.h"

NSString * const TEPreviousScene = @"TEPreviousScene";

@implementation TESceneController

@synthesize container, context, currentScene, scenes;

- (id)init
{
  self = [super init];
  if (self) {
    scenes = [[NSMutableDictionary alloc] init];
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    container = [[UIView alloc] initWithFrame:self.view.frame];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:container];
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

-(void)addScene:(UIViewController *)scene named:(NSString *)name {
  [self addChildViewController:scene];
  
  if ([scene isKindOfClass:[GLKViewController class]])
    ((GLKView*)scene.view).context = context;
  [scenes setObject:scene forKey:name];
}

-(void)removeScene:(NSString *)name {
  [[scenes objectForKey:name] removeFromParentViewController];
  [scenes removeObjectForKey:name];
}

-(void)displayScene:(NSString *)name {
  [self displayScene:name duration:3 options:(UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionCrossDissolve) completion:NULL];
}

-(void)displayScene:(NSString *)name  duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
  UIViewController *newScene = name == TEPreviousScene ? previousScene : [scenes objectForKey:name];
  if (currentScene == nil)
    [container addSubview:newScene.view];
  else {
    previousScene = currentScene;
    [UIView transitionFromView:currentScene.view toView:newScene.view duration:duration options:options completion:completion];
  }
  currentScene = newScene;
}

# pragma mark Device Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (currentScene != nil)
    return [currentScene shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
  else
    return YES;
}

@end
