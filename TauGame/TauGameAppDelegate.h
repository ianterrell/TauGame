//
//  TauGameAppDelegate.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "TauEngine.h"
#import "MainMenuViewController.h"

@interface TauGameAppDelegate : UIResponder <UIApplicationDelegate> {
  TESceneController *sceneController;
  MainMenuViewController *mainMenuController;
}

@property (strong, nonatomic) UIWindow *window;

-(void)showSceneController;
-(void)showMainMenuController;

@end
