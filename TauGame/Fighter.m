//
//  Fighter.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Fighter.h"

#define BULLET_X_SPREAD_FACTOR 3.2
#define BULLET_Y_SPREAD_FACTOR 3.0
#define BULLET_Y_VELOCITY 6.0
#define BULLET_X_VELOCITY_FACTOR 0.75

#define MAX_BULLETS 5

#define MAX_VELOCITY 10
#define ACCELEROMETER_SENSITIVITY 35

@implementation Fighter

+(void)initialize {
  [[TESoundManager sharedManager] load:@"fighter-hurt"];
  [[TESoundManager sharedManager] load:@"shoot"];
}

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"fighter"];
    
    // Set up guns
    numBullets = 1;
    spreadAmount = 0;
    
    self.maxVelocity = MAX_VELOCITY;
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self wraparoundXInScene:scene];
  
  self.velocity = GLKVector2Make(ACCELEROMETER_SENSITIVITY*[TEAccelerometer horizontal], 0);
}

-(void)shootInScene:(FighterScene *)scene {
  [[TESoundManager sharedManager] play:@"shoot"];
  int middle = numBullets / 2;
  for (int i = 0; i < numBullets; i++) {
    TECharacter *bullet = [[Bullet alloc] init];

    float x = self.position.x;
    float xOffset = -1*((float)(middle-i))/BULLET_X_SPREAD_FACTOR;
    xOffset += numBullets % 2 == 0 ? 1.0/(2.0*BULLET_X_SPREAD_FACTOR) : 0;
    x += xOffset;
    
    float y = self.position.y + 1.1;
    y -= ABS(((float)(middle-i))/BULLET_Y_SPREAD_FACTOR);
    y -= (numBullets % 2 == 0) && (i >= middle) ? ABS(1.0/BULLET_Y_SPREAD_FACTOR) : 0;
    
    bullet.position = GLKVector2Make(x, y);  
    bullet.velocity = GLKVector2Make(xOffset * spreadAmount * BULLET_X_VELOCITY_FACTOR, BULLET_Y_VELOCITY);
    [scene.characters addObject:bullet];
    [scene.bullets addObject:bullet];
  }
}

-(void)registerHit {
  [[TESoundManager sharedManager] play:@"fighter-hurt"];
  
  TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
  highlight.color = GLKVector4Make(1, 0, 0, 1);
  highlight.duration = 0.1;
  highlight.reverse = YES;
  [self.currentAnimations addObject:highlight];
}

-(void)getPowerup:(Powerup *)powerup {
  [[TESoundManager sharedManager] play:@"powerup"];
  
  if (numBullets < MAX_BULLETS)
    numBullets++;
  
  if (numBullets == MAX_BULLETS && spreadAmount < 2)
    spreadAmount++;
}

@end
