//
//  SeekNShoot.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Seeker.h"
#import "Bullet.h"
#import "Game.h"
#import "ClassicHorde.h"
#import "Fighter.h"

@implementation Seeker

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"seeker"];
    shotSpeed = 1.0;
    shotDelay = 0.0;
    self.maxVelocity = 2;
    
    accelerationFactor = [TERandom randomFractionFrom:0.75 to:3];
    
    self.scale = 0.6;
    
    // Animate!
    TENode *pupil = [self childNamed:@"pupil"];
    TETranslateAnimation *animation = [[TETranslateAnimation alloc] init];
    animation.translation = GLKVector2Make(2.05,0);
    animation.reverse = YES;
    animation.repeat = kTEAnimationRepeatForever;
    animation.duration = 0.5;
    [pupil startAnimation:animation];
    
    // Colorize!
    self.shape.renderStyle = kTERenderStyleVertexColors;
    self.shape.colorVertices[0] = GLKVector4Make(0.4,0.4,0.4,1);
    for (int i = 1; i < self.shape.numVertices; i++)
      self.shape.colorVertices[i] = GLKVector4Make(0.1,0.1,0.1,1);
    self.shape.colorVertices[2] = self.shape.colorVertices[5] = GLKVector4Make(0.2,0.2,0.2,1);
  }
  
  return self;
}

-(void)shootInScene:(Game *)scene {
  // Can't shoot if dead!
  if ([self dead])
    return;
  
  shotDelay = 1.0;
  [[TESoundManager sharedManager] play:@"shoot"];

  TECharacter *bullet = [[Bullet alloc] init];
    
  float x = self.position.x;
  float y = self.position.y - 1;
  bullet.position = GLKVector2Make(x, y);  
  bullet.velocity = GLKVector2Make(0, -5);
  bullet.shape.color = GLKVector4Make(1,0,0,1);
  [scene addCharacterAfterUpdate:bullet];
  [scene.enemyBullets addObject:bullet];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  Game *fighterScene = (Game*)scene;
  float fighterX = fighterScene.fighter.position.x;
  float diff = fighterX- self.position.x;
  self.acceleration = GLKVector2MultiplyScalar(GLKVector2Make(diff,0),accelerationFactor);
  
  if (shotDelay > 0)
    shotDelay -= dt;
  
  if (ABS(diff) < 0.5 && shotDelay <= 0) {
    [self shootInScene:(Game*)scene];
  }
}

@end
