//
//  TauGameAppDelegate.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauGameAppDelegate.h"
#import "GameController.h"
#import "TitleScreen.h"
#import "Game.h"
#import "Pause.h"
#import "Credits.h"
#import "Icons.h"

GameController *gameController;

@implementation TauGameAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[TauEngine motionManager] startAccelerometerUpdates];
  
  gameController = [GameController sharedController];
  [gameController addSceneOfClass:[TitleScreen class] named:@"menu"];
  [gameController addSceneOfClass:[Pause class] named:@"pause"];
  [gameController addSceneOfClass:[Credits class] named:@"credits"];
  
  #ifdef DEBUG_INITIAL_SCENE
    [gameController displayScene:DEBUG_INITIAL_SCENE];
  #else
    #ifdef MAKING_ICONS
      [gameController addSceneOfClass:[Icons class] named:@"icons"];
      [gameController displayScene:@"icons"];
    #else
      [gameController displayScene:@"menu"];
    #endif
  #endif
  
  [gameController playMusic];
  [gameController setupGameKit];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
  self.window.rootViewController = gameController;
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
    NSLog(@"will enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
  NSLog(@"will enter foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  NSLog(@"did become active");
  GLKViewController *scene = (GLKViewController*)gameController.currentScene;
  if ([scene isKindOfClass:[Game class]])
    [(Game*)scene pauseGame];
  else
    scene.paused = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
    NSLog(@"will terminate");
}

@end
