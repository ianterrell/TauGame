//
//  TESceneController.h
//  TauGame
//
//  Created by Ian Terrell on 7/18/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "TEScene.h"

@interface TESceneController : GLKViewController {
  EAGLContext *context;
  NSMutableDictionary *scenes;
  TEScene *currentScene;
}

@property(strong, readonly) EAGLContext *context;
@property(strong, readonly) TEScene *currentScene;
@property(strong, readonly) NSMutableDictionary *scenes;

# pragma mark The Controller

+(TESceneController *)sharedController;

# pragma mark Scene Management

-(void)addScene:(TEScene *)scene named:(NSString *)name;
-(void)displayScene:(NSString *)name;

@end
