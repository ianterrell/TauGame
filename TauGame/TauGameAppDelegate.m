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
  
  // def need yaml or Ruby! verbose bullshit!
  TETriangle *mageBodyTriangle = [[TETriangle alloc] init];
  mageBodyTriangle.vertex0 = GLKVector2Make(0.0, -3.0);
  mageBodyTriangle.vertex1 = GLKVector2Make(1.0, 0.0);
  mageBodyTriangle.vertex2 = GLKVector2Make(-1.0, 0.0);
  mageBodyTriangle.color = GLKVector4Make(0.1, 0.1, 0.9, 1.0);
  
  TECharacter *mage = [[TECharacter alloc] init];
  mage.shape = mageBodyTriangle;
  mage.shape.parent = mage;
  mage.name = @"Mage";
  mage.translation = GLKVector2Make(3.0, 0.0);
  mage.rotation = 0.25 * M_TAU;
  
  TEEllipse *mageBodyHead = [[TEEllipse alloc] init];
  mageBodyHead.color = GLKVector4Make(0.3, 0.5, 0.2, 1.0);
  mageBodyHead.scale = 0.5;
  mageBodyHead.translation = GLKVector2Make(0.0, 1.0);
  TENode *mageBodyHeadNode = [[TENode alloc] init];
  mageBodyHeadNode.name = @"Head";
  mageBodyHeadNode.shape = mageBodyHead;
  mageBodyHeadNode.shape.parent = mageBodyHeadNode;
  [mage addChild:mageBodyHeadNode];
  
  TEScene *scene = view.scene;
  [scene setLeft:-6.4 right:6.4 bottom:-8.53 top:8.53];
  scene.clearColor = GLKVector4Make(0.5, 0.6, 0.5, 0.5);
  [scene.characters addObject:mage];
  
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
