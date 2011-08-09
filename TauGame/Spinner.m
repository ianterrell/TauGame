//
//  Spinner.m
//  TauGame
//
//  Created by Ian Terrell on 8/7/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Spinner.h"
#import "Game.h"
#import "Fighter.h"
#import "GlowingBullet.h"

@implementation Spinner

+(BOOL)shootTowardFighter {
  return YES;
}

- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"spinner"];
    shotDelayConstant = 1;
    self.maxVelocity = 3;
    self.maxAcceleration = 2;
    
    [self resetShotDelay];
  }
  
  return self;
}

-(GLKVector4)bulletColor {
  return GLKVector4Make(1,1,0,1);
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  [self bounceXInScene:scene buffer:0.5];
  
  float accelerationFactor = 1.0;
  
  Game *fighterScene = (Game*)scene;
  
  GLKVector2 diff = [self vectorToNode:fighterScene.fighter];
  
  self.acceleration = GLKVector2MultiplyScalar(GLKVector2Make(-scene.width/diff.x,0),accelerationFactor);
  self.rotation = diff.y == 0 ? 0 : -atan(diff.x/diff.y);  
}

@end
