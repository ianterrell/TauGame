//
//  TauGameAppDelegate.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauGameAppDelegate.h"
#import "TauEngine.h"

@implementation TauGameAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  glkViewController = [[GLKViewController alloc] initWithNibName:@"GLKViewController" bundle:nil];
  
  TESceneView *view = [[TESceneView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
  
  [EAGLContext setCurrentContext:context];
  
  glkViewController.view = view;
  glkViewController.delegate = view.scene;
  glkViewController.preferredFramesPerSecond = 60;
  
  view.drawableMultisample = GLKViewDrawableMultisample4X;
    
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = glkViewController;
  [self.window makeKeyAndVisible];
  
  // Let's build a test scene!
  TEScene *scene = view.scene;
  [scene setLeft:-6.4 right:6.4 bottom:-8.53 top:8.53];
  scene.clearColor = GLKVector4Make(0.5, 0.6, 0.5, 0.5);
  
  TECharacter *mage = [TECharacterLoader loadCharacterFromJSONFile:@"mage"];
  [scene.characters addObject:mage];
  
  TEAnimation *grow = [[TEAnimation alloc] init];
  grow.type = TEAnimationScale;
  grow.value0 = 1.5;
  grow.duration = 2.0;
  [mage.currentAnimations addObject:grow];
  
  TEAnimation *spin = [[TEAnimation alloc] init];
  spin.type = TEAnimationRotate;
  spin.value0 = M_TAU;
  spin.duration = 2.0;
  spin.repeat = 1;
  [mage.currentAnimations addObject:spin];
  
  [mage traverseUsingBlock:^(TENode *node){
    NSLog(@"Node %@ has %d animations", node.name, [node.currentAnimations count]);
  }];
  
//  TECharacter *mage2 = [TECharacterLoader loadCharacterFromJSONFile:@"mage"];
//  mage2.scale = 0.5;
//  mage2.translation = GLKVector2Make(-3.0, -3.0);
//  mage2.rotation = 0.25*M_TAU;
//  [scene.characters addObject:mage2];
//  
//  TECharacter *mage3 = [TECharacterLoader loadCharacterFromJSONFile:@"mage"];
//  mage3.scale = 2;
//  mage3.translation = GLKVector2Make(3.0, 3.0);
//  mage3.rotation = -0.5*M_TAU;
//  [scene.characters addObject:mage3];
  
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
