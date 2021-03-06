//
//  SeekNShoot.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Seeker.h"
#import "GlowingBullet.h"
#import "Game.h"
#import "ClassicHorde.h"
#import "Fighter.h"

@implementation Seeker

@synthesize accelerationFactor, distanceToShoot;

- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"seeker"];

    shotDelayConstant = FRAY_SEEKER_SHOT_DELAY_CONSTANT_INITIAL;
    distanceToShoot = FRAY_SEEKER_SHOT_DISTANCE_INITIAL;
    self.maxVelocity = FRAY_SEEKER_MAX_VELOCITY_INITIAL;
    accelerationFactor = FRAY_SEEKER_MAX_ACCEL_FACTOR_INITIAL;
    
    // Animate!
    TENode *pupil = [self childNamed:@"pupil"];
    TETranslateAnimation *animation = [[TETranslateAnimation alloc] init];
    animation.translation = GLKVector2Make(1.025,0);
    animation.reverse = YES;
    animation.repeat = kTEAnimationRepeatForever;
    animation.duration = 0.5;
    [pupil startAnimation:animation];
    
    [self resetShotDelay];
  }
  
  return self;
}

-(float)bulletInitialYOffset {
  return 0.1667*scaleY;
}

-(GLKVector4)bulletColor {
  return GLKVector4Make(1,0,0,1);
}

-(BOOL)readyToShoot {
  return (ABS(distanceToFighter) < distanceToShoot && shotDelay <= 0);
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  distanceToFighter = ((Game*)scene).fighter.position.x- self.position.x;
  self.acceleration = GLKVector2Make(distanceToFighter*accelerationFactor,0);
}

@end
