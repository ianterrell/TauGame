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

@property float shotDelayConstant, shotDelayMin, shotDelayMax;

# pragma mark - Shooting

+(BaddieShootingStyle)shootingStyle;
+(BOOL)shootTowardFighter;
-(float)bulletVelocity;
-(GLKVector4)bulletColor;
-(BOOL)ableToShootInScene:(Game*)scene;
-(BOOL)readyToShoot;
-(void)updateShotDelay:(NSTimeInterval)dt;
-(void)resetShotDelay;
-(void)shootInScene:(Game *)scene;
-(void)shootInDirection:(GLKVector2)direction inScene:(Game*)scene;
-(void)shootInDirection:(GLKVector2)direction inScene:(Game*)scene xOffset:(float)xOffset;
-(void)fire:(Bullet *)bullet in:(Game*)scene;

# pragma mark - Eyes

+(BOOL)blinks;
-(void)resetBlinkDelay;
-(void)updateBlink:(NSTimeInterval)dt;
-(void)blink;
-(TEColorAnimation *)redEyeAnimationForNode:(TENode *)node;

@end
