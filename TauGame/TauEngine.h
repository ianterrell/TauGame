//
//  TEEngine.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#define M_TAU (2*M_PI)

#define TE_ELLIPSE_RESOLUTION 62
#define TE_ELLIPSE_NUM_VERTICES (TE_ELLIPSE_RESOLUTION + 2)

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>

#import "TEDrawable.h"
#import "TENode.h"
#import "TECharacter.h"
#import "TEShape.h"
#import "TETriangle.h"
#import "TEEllipse.h"
#import "TERectangle.h"

#import "TEScene.h"
#import "TESceneController.h"

#import "TECharacterLoader.h"

#import "TEAnimation.h"
#import "TEScaleAnimation.h"
#import "TETranslateAnimation.h"
#import "TERotateAnimation.h"
#import "TEColorAnimation.h"

#import "TECollisionDetector.h"

#import "TEAdjustedAttitude.h"
#import "TEAccelerometer.h"

#import "TESoundManager.h"

@interface TauEngine : NSObject {
  CMMotionManager *motionManager;
}

+(CMMotionManager *)motionManager;

@end

