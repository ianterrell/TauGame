//
//  TESceneView.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "TEScene.h"

@interface TESceneView : GLKView {
  TEScene *scene;
}

@property(strong, nonatomic) TEScene *scene;

@end
