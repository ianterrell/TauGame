//
//  TauGameAppDelegate.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface TauGameAppDelegate : UIResponder <UIApplicationDelegate> {
  GLKViewController *glkViewController;
  UILabel *label;
}

@property (strong, nonatomic) UIWindow *window;

@end
