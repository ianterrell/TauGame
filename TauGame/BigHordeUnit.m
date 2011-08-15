//
//  BigHordeUnit.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "BigHordeUnit.h"
#import "HordeUnit.h"

@implementation BigHordeUnit

+(BOOL)blinks {
  return YES;
}

+(BaddieShootingStyle)shootingStyle {
  return kBaddieRandomShot;
}


- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"horde-unit"];
    [HordeUnit randomlyColorizeUnit:self];

    self.scale = 2;
    drop = YES;
    
    [self resetShotDelay];
  }
  
  return self;
}

-(void)setupInGame:(Game*)game {
  [super setupInGame:game];
  [game.enemyBullets addObject:self]; // for drop
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  [super bounceXInScene:scene bufferLeft:1 bufferRight:1];
  [super bounceYInScene:scene bufferTop:2 bufferBottom:3];
}

-(void)shootInScene:(Game *)scene {
  [self resetShotDelay];
  
  if (![self ableToShootInScene:scene])
    return;
  
  drop = !drop;
  if (drop) {
    GLKVector2 previousVelocity = velocity;
    GLKVector2 previousAcceleration = acceleration;
    self.velocity = GLKVector2Make(0, 0);
    self.acceleration = GLKVector2Make(0, 0);
    
    TETranslateAnimation *dropAnimation = [[TETranslateAnimation alloc] init];
    dropAnimation.translation = GLKVector2Make(0, -1*self.position.y+1);
    dropAnimation.duration = -1*dropAnimation.translation.y*0.1;
    dropAnimation.reverse = YES;
    dropAnimation.onRemoval = ^(){
      self.velocity = previousVelocity;
      self.acceleration = previousAcceleration;
    };
    
    TETranslateAnimation *shake = [[TETranslateAnimation alloc] init];
    shake.translation = GLKVector2Make(0, 0.2);
    shake.duration = 0.1;
    shake.reverse = YES;
    shake.repeat = 2;
    shake.onRemoval = ^() {
      [Sfx baddieDrop];
      [self startAnimation:dropAnimation];
    };
    
    [self startAnimation:shake];
  } else {
    [Sfx baddieShoot];
    [self shootInDirection:GLKVector2Make(0, -1) inScene:scene];
    [self shootInDirection:GLKVector2Make(0.5, -1) inScene:scene];
    [self shootInDirection:GLKVector2Make(-0.5, -1) inScene:scene];    
  }
}

@end
