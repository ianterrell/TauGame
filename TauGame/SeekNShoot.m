//
//  SeekNShoot.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "SeekNShoot.h"
#import "FighterScene.h"
#import "BaddieField.h"
#import "Fighter.h"

@implementation SeekNShoot

- (id)init
{
  self = [super init];
  if (self) {
    shotSpeed = 1.0;
    shotDelay = 0.0;
    self.maxVelocity = 2;
  }
  
  return self;
}

-(void)shootInScene:(BaddieField *)scene {
  // Can't shoot if dead!
//  if ([self dead])
//    return;
  
  shotDelay = 1.0;
  [[TESoundManager sharedManager] play:@"shoot"];

  TECharacter *bullet = [[Bullet alloc] init];
    
  float x = self.position.x;
  float y = self.position.y - 1;
  bullet.position = GLKVector2Make(x, y);  
  bullet.velocity = GLKVector2Make(0, -5);
  bullet.shape.color = self.shape.color;
  [scene addCharacterAfterUpdate:bullet];
  [scene.baddieBullets addObject:bullet];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  FighterScene *fighterScene = (FighterScene*)scene;
  float fighterX = fighterScene.fighter.position.x;
  float diff = fighterX- self.position.x;
  self.acceleration = GLKVector2Make(diff,0);
  
  if (shotDelay > 0)
    shotDelay -= dt;
  
  if (diff < 0.5 && shotDelay <= 0) {
    [self shootInScene:(BaddieField*)scene];
  }
}

@end
