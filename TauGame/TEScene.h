//
//  TEScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TEScene : NSObject <GLKViewDelegate, GLKViewControllerDelegate> {
  GLfloat left, right, bottom, top;
  NSMutableArray *characters;
}

-(void)render;

@end
