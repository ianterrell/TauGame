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

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"spinner"];
    shotDelay = 1;
    self.maxVelocity = 3;
    self.maxAcceleration = 2;
  }
  
  return self;
}

-(void)shootInScene:(Game *)scene {
  // Can't shoot if dead!
  if ([self dead])
    return;
  
  shotDelay = 1.0;
  [[TESoundManager sharedManager] play:@"shoot"];
  
  GLKVector2 diff = [self vectorToNode:scene.fighter];
  GLKVector2 normalizedDiff = GLKVector2Normalize(diff);
  
  
  TECharacter *bullet = [[GlowingBullet alloc] initWithColor:GLKVector4Make(1,1,0,1)];
  
  bullet.rotation = diff.y == 0 ? 0 : atan(diff.x/diff.y);
  bullet.position = GLKVector2Add(self.position,GLKVector2MultiplyScalar(normalizedDiff, 0.5));
  bullet.velocity = GLKVector2MultiplyScalar(normalizedDiff,3);
  [scene addCharacterAfterUpdate:bullet];
  [scene.enemyBullets addObject:bullet];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  [self bounceXInScene:scene buffer:0.5];
  
  float accelerationFactor = 1.0;
  
  Game *fighterScene = (Game*)scene;
  
  GLKVector2 diff = [self vectorToNode:fighterScene.fighter];
  
  self.acceleration = GLKVector2MultiplyScalar(GLKVector2Make(-scene.width/diff.x,0),accelerationFactor);
  
  self.rotation = diff.y == 0 ? 0 : -atan(diff.x/diff.y);
  
  if (shotDelay > 0)
    shotDelay -= dt;
  
  if (shotDelay <= 0) {
    [self shootInScene:(Game*)scene];
  }
}

@end
