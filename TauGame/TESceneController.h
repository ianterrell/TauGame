//
//  TESceneController.h
//  TauGame
//
//  Created by Ian Terrell on 7/18/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "TEScene.h"

@interface TESceneController : UIViewController {
  UIView *container;
  
  EAGLContext *context;
  NSMutableDictionary *scenes;
  UIViewController *currentScene;
}

@property(strong, readonly) UIView *container;
@property(strong, readonly) EAGLContext *context;
@property(strong, readonly) UIViewController *currentScene;
@property(strong, readonly) NSMutableDictionary *scenes;

# pragma mark The Controller

+(TESceneController *)sharedController;

# pragma mark Scene Management

-(void)addScene:(UIViewController *)scene named:(NSString *)name;
-(void)removeScene:(NSString *)name;
-(void)displayScene:(NSString *)name;
-(void)displayScene:(NSString *)name  duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;

@end
