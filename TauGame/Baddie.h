//
//  Baddie.h
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Enemy.h"
#import "Game.h"
#import "Bullet.h"

typedef enum {
  kBaddieConstantShot,
  kBaddieRandomShot
} BaddieShootingStyle;

@interface Baddie : Enemy {
  float blinkDelay;
  float shotDelay, shotDelayConstant, shotDelayMin, shotDelayMax;
}

# pragma mark - Shooting

+(BaddieShootingStyle)shootingStyle;
+(BOOL)shootTowardFighter;
-(float)bulletVelocity;
-(GLKVector4)bulletColor;
-(BOOL)readyToShoot;
-(void)updateShotDelay:(NSTimeInterval)dt;
-(void)resetShotDelay;
-(void)shootInScene:(Game *)scene;
-(void)fire:(Bullet *)bullet in:(Game*)scene;

# pragma mark - Blinking

+(BOOL)blinks;
-(void)resetBlinkDelay;
-(void)updateBlink:(NSTimeInterval)dt;
-(void)blink;

@end
