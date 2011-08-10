//
//  Baddie.m
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"
#import "GlowingBullet.h"
#import "Fighter.h"

#define BLINK_MIN 2
#define BLINK_MAX 11

@implementation Baddie

- (id)init
{
  self = [super init];
  if (self) {
    hitPoints = 3;
    
    shotDelayConstant = shotDelayMin = shotDelayMax = 5; // defaults
    
    [self resetBlinkDelay];
    [self resetShotDelay];
  }
  
  return self;
}

# pragma mark - Updating

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  [self updateShotDelay:dt];
  if ([self readyToShoot])
    [self shootInScene:(Game*)scene];
  
  if ([[self class] blinks])
    [self updateBlink:dt];
}

# pragma mark - Shooting

+(BaddieShootingStyle)shootingStyle {
  return kBaddieConstantShot;
}

+(BOOL)shootTowardFighter {
  return NO;
}

-(float)bulletVelocity {
  return 5;
}

-(GLKVector4)bulletColor {
  return self.shape.color;
}

-(float)bulletInitialYOffset {
  return 1;
}

-(void)updateShotDelay:(NSTimeInterval)dt {
  if (shotDelay > 0)
    shotDelay -= dt;
}

-(void)resetShotDelay {
  switch ([[self class] shootingStyle]) {
    case kBaddieConstantShot:
      shotDelay = shotDelayConstant;
      break;
    case kBaddieRandomShot:
      shotDelay = [TERandom randomFractionFrom:shotDelayMin to:shotDelayMax];
      break;
    default:
      shotDelay = MAX(shotDelayMax,shotDelayConstant);
      break;
  }
}

-(BOOL)readyToShoot {
  return shotDelay <= 0;
}

-(void)shootInScene:(Game *)scene {
  if ([self dead] || scene.gameIsOver)
    return;
  
  [self resetShotDelay];
  
  [[TESoundManager sharedManager] play:@"shoot"];
  
  if ([[self class] shootTowardFighter])
    [self shootInDirection:[self vectorToNode:scene.fighter] inScene:scene];
  else
    [self shootInDirection:GLKVector2Make(0,-1) inScene:scene];
}

-(void)shootInDirection:(GLKVector2)direction inScene:(Game*)scene {
  [self shootInDirection:direction inScene:scene xOffset:0];
}

-(void)shootInDirection:(GLKVector2)direction inScene:(Game*)scene xOffset:(float)xOffset {
  Bullet *bullet = [[GlowingBullet alloc] initWithColor:[self bulletColor]];
  if (!GLKVector2AllEqualToVector2(direction, GLKVector2Make(0,-1))) {
    GLKVector2 normalized = GLKVector2Normalize(direction);
    bullet.rotation = direction.y == 0 ? 0 : atan(direction.x/direction.y);
    bullet.position = GLKVector2Add(self.position,GLKVector2MultiplyScalar(normalized, [self bulletInitialYOffset]));
    bullet.position = GLKVector2Make(bullet.position.x+xOffset,bullet.position.y);
    bullet.velocity = GLKVector2MultiplyScalar(normalized,[self bulletVelocity]);
  } else {
    bullet.position = GLKVector2Make(self.position.x+xOffset, self.position.y - [self bulletInitialYOffset]);
    bullet.velocity = GLKVector2Make(0,-1*[self bulletVelocity]);
  }
  [self fire:bullet in:scene];  
}

-(void)fire:(Bullet *)bullet in:(Game*)scene {
  [scene addCharacterAfterUpdate:bullet];
  [scene.enemyBullets addObject:bullet];
}

# pragma mark - Blinking

+(BOOL)blinks {
  return NO;
}

-(void)resetBlinkDelay {
  blinkDelay = [TERandom randomFractionFrom:BLINK_MIN to:BLINK_MAX];
}

-(void)updateBlink:(NSTimeInterval)dt {
  if (blinkDelay > 0)
    blinkDelay -= dt;
  if (blinkDelay <= 0)
    [self blink];
}

-(void)blink {
  [self resetBlinkDelay];
  TENode *eyes = [self childNamed:@"eyes"];
  TEScaleAnimation *animation = [[TEScaleAnimation alloc] init];
  animation.scaleY = 0.25;
  animation.reverse = YES;
  animation.duration = 0.1;
  [eyes startAnimation:animation];
}

# pragma mark - 'Sploding

-(void)explode {
  self.collide = NO;
  
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 0.0;
  scaleAnimation.duration = 0.5;
  scaleAnimation.onRemoval= ^(){
    self.remove = YES;
  };
  [self startAnimation:scaleAnimation];
  
  TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
  rotateAnimation.rotation = [TERandom randomFraction] * 2 * M_TAU;
  rotateAnimation.duration = 0.5;
  [self startAnimation:rotateAnimation];
}

@end