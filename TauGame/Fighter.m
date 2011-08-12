//
//  Fighter.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "Fighter.h"
#import "Bullet.h"
#import "GlowingBullet.h"
#import "ShotTimer.h"
#import "ExtraBullet.h"
#import "ExtraLife.h"
#import "ExtraShot.h"
#import "ExtraHealth.h"
#import "ScoreBonus.h"

static GLKVector4 healthyColor, unhealthyColor;

NSString * const FighterDiedNotification = @"FighterDiedNotification";
NSString * const FighterExtraLifeNotification = @"FighterExtraLifeNotification";
NSString * const FighterExtraShotNotification = @"FighterExtraShotNotification";

@implementation Fighter

@synthesize lives, numShots, shotTimers;

+(void)initialize {
  [[TESoundManager sharedManager] load:@"fighter-hurt"];
  [[TESoundManager sharedManager] load:@"shoot"];
  
  healthyColor = GLKVector4Make(0.188,0.761,0.0,1.0);
  unhealthyColor = GLKVector4Make(0.9,0.9,0.9,1.0);
}

+(int)initialLives {
  return FIGHTER_INITIAL_LIVES;
}

+(int)initialHealth {
  return FIGHTER_INITIAL_HEALTH;
}

+(int)maxHealth {
  return FIGHTER_MAX_HEALTH;
}

- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"fighter"];
    
    // Set up lives
    lives = [[self class] initialLives];
    
    // Set up health
    health = [[self class] initialHealth];
    maxHealth = [[self class] maxHealth];
    healthShapes = [self childrenNamed:[NSArray arrayWithObjects:@"health0", @"health1", @"health2", nil]];
    
    // Set up guns
    shotSpeed = FIGHTER_INITIAL_SHOT_SPEED;
    numBullets = FIGHTER_INITIAL_NUM_BULLETS;
    spreadAmount = 0;
    
    numShots = 0;
    shotTimers = [NSMutableArray arrayWithCapacity:FIGHTER_MAX_SHOTS];
    for (int i = 0; i < FIGHTER_INITIAL_NUM_SHOTS; i++)
      [self addExtraShot];
    
    // Root body is for collision only
    self.shape.renderStyle = kTERenderStyleNone;
    body = [self childNamed:@"body double"];
    
    paused = NO;
    
    self.maxVelocity = FIGHTER_MAX_VELOCITY;
    yRotation = 0.0;
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self wraparoundXInScene:scene];
  
  if (!paused) {
    self.velocity = GLKVector2Make(FIGHTER_ACCELEROMETER_SENSITIVITY*[TEAccelerometer horizontalForOrientation:[GameController sharedController].interfaceOrientation], 0);
    yRotation = MIN(1,MAX(-1,self.velocity.x / FIGHTER_TURN_FACTOR)) * FIGHTER_MAX_TURN*M_TAU;
  }
}

-(void)shootInScene:(Game *)scene {
  // Can't shoot if dead!
  if ([self dead])
    return;
  
  // Can't shoot if we don't have a timer available!
  BOOL fired = NO;
  for (ShotTimer *timer in shotTimers) {
    if ([timer ready]) {
      [timer fireWithTime:shotSpeed];
      fired = YES;
      break;
    }
  }
  if (!fired)
    return;
  
  [[TESoundManager sharedManager] play:@"shoot"];
  int middle = numBullets / 2;
  for (int i = 0; i < numBullets; i++) {
    TENode *bullet = [[GlowingBullet alloc] initWithColor:GLKVector4Make(1,1,1,1)];

    float x = self.position.x;
    float xOffset = -1*((float)(middle-i))/FIGHTER_BULLET_X_SPREAD_FACTOR;
    xOffset += numBullets % 2 == 0 ? 1.0/(2.0*FIGHTER_BULLET_X_SPREAD_FACTOR) : 0;
    x += xOffset;
    
    float y = self.position.y + 1.1;
    y -= ABS(((float)(middle-i))/FIGHTER_BULLET_Y_SPREAD_FACTOR);
    y -= (numBullets % 2 == 0) && (i >= middle) ? ABS(1.0/FIGHTER_BULLET_Y_SPREAD_FACTOR) : 0;
    
    bullet.position = GLKVector2Make(x, y);  
    bullet.velocity = GLKVector2Make(xOffset * spreadAmount * FIGHTER_BULLET_X_VELOCITY_FACTOR, FIGHTER_BULLET_Y_VELOCITY);
    [scene.characters insertObject:bullet atIndex:3];
    [scene.bullets addObject:bullet];
  }
}

-(BOOL)dead {
  return health <= 0;
}

-(BOOL)gameOver {
  return [self dead] && lives <= 0;
}

-(void)setHealth:(int)_health {
  health = MIN(_health,maxHealth);
  
  for (int i = 0; i < 3; i++) {
    float factor = MAX(0,MIN(1,(float)(health - i*maxHealth/3)/(maxHealth/3)));
    GLKVector4 newColor = GLKVector4Add(unhealthyColor,GLKVector4MultiplyScalar(GLKVector4Subtract(healthyColor, unhealthyColor), factor));
    ((TENode *)[healthShapes objectAtIndex:i]).shape.color = newColor;
  }
}

-(void)decrementHealth:(int)amount {
  [self setHealth:health-amount];
}

-(void)incrementHealth:(int)amount {
  [self setHealth:health+amount];
}

-(void)makeTemporarilyInvincible {
  collide = NO;
  
  TEColorAnimation *transparent = [[TEColorAnimation alloc] initWithNode:self];
  transparent.color = GLKVector4Make(1, 1, 1, 0.6);
  transparent.duration = 0.25;
  transparent.reverse = YES;
  transparent.repeat = 1;
  transparent.onRemoval = ^(){
    collide = YES;
  };
  [body.currentAnimations addObject:transparent];  
}

// lotta dupe code
-(void)flyAwayPowerup:(Powerup*)powerup inScene:(Game *)scene {
  powerup.position = self.position;
  
  TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
  rotateAnimation.rotation = [TERandom randomFractionFrom:-2 to:2] * M_TAU;
  rotateAnimation.duration = 1.5;
  [powerup startAnimation:rotateAnimation];
  
  TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
  translateAnimation.translation = GLKVector2Make([TERandom randomFractionFrom:-3 to:3], [TERandom randomFractionFrom:0 to:3]);
  translateAnimation.duration = 1.5;
  [powerup startAnimation:translateAnimation];
  
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 0.0;
  scaleAnimation.duration = 1.5;
  scaleAnimation.onRemoval = ^(){
    powerup.remove = YES;
  };
  [powerup startAnimation:scaleAnimation];

  [scene addCharacterAfterUpdate:powerup];
}

-(void)removePowerupsInScene:(Game *)scene {
  spreadAmount = 0;
  
  if (numBullets > 1) {
    numBullets--;
    [self flyAwayPowerup:[[ExtraBullet alloc] init] inScene:scene];
  }

  if (numShots > 1) {
    numShots--;
    ((TENode*)[shotTimers lastObject]).remove = YES;
    [shotTimers removeLastObject];
    [self flyAwayPowerup:[[ExtraShot alloc] init] inScene:scene];
  }
}

-(void)explodeInScene:(Game *)scene {
  lives--;
  [self postNotification:FighterDiedNotification];
  BOOL resurrect = ![self gameOver];
  
  #ifndef DEBUG_KEEP_POWERUPS
    [self removePowerupsInScene:scene];
  #endif
  
  self.velocity = GLKVector2Make(0,0);
  collide = NO;
  paused = YES;
  
  __block BOOL setCallback = NO;
  [self traverseUsingBlock:^(TENode *node){
    if (node != self) {
      TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
      rotateAnimation.rotation = [TERandom randomFractionFrom:-2 to:2] * M_TAU;
      rotateAnimation.duration = 1.5;
      rotateAnimation.reverse = resurrect;
      [node.currentAnimations addObject:rotateAnimation];
    
      TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
      translateAnimation.translation = GLKVector2Make([TERandom randomFractionFrom:-3 to:3], [TERandom randomFractionFrom:0 to:3]);
      translateAnimation.duration = 1.5;
      translateAnimation.reverse = resurrect;
      [node.currentAnimations addObject:translateAnimation];
      
      TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
      scaleAnimation.scale = 0.0;
      scaleAnimation.duration = 1.5;
      scaleAnimation.reverse = resurrect;
      
      if (!setCallback) {
        scaleAnimation.onRemoval= ^(){
          if (resurrect) {
            collide = YES;
            paused = NO;
            [self setHealth:maxHealth];
            [self makeTemporarilyInvincible];
          }
          else
            remove = YES;
        };
        setCallback = YES;
      }
      
      [node startAnimation:scaleAnimation];
    }
  }];
}

-(void)registerHitInScene:(Game *)scene {
  [[TESoundManager sharedManager] play:@"fighter-hurt"];

  [self decrementHealth:1];
  
  if ([self dead]) {
    #ifndef DEBUG_INVINCIBLE
      [self explodeInScene:scene];
    #else
      NSLog(@"Would have died if not for powers!");
      self.health = maxHealth;
      [self makeTemporarilyInvincible];
    #endif
  } else {
    TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
    highlight.color = GLKVector4Make(1, 0, 0, 1);
    highlight.duration = 0.1;
    highlight.reverse = YES;
    [body.currentAnimations addObject:highlight];
    [self makeTemporarilyInvincible];
  }
}

-(void)getPowerup:(Powerup *)powerup inScene:(Game*)scene {
  NSString *sound = @"powerup";
  int score = 0;
  
  // Score Bonus
  if ([powerup isKindOfClass:[ScoreBonus class]]) 
  {
    score = POWERUP_SCORE_SCORE;
    sound = @"score-bonus";
  } 
  
  // Extra Bullet
  else if ([powerup isKindOfClass:[ExtraBullet class]]) 
  {
    score = POWERUP_WEAPON_SCORE;
    if (numBullets < FIGHTER_MAX_BULLETS)
      numBullets++;
    
    #ifdef FIGHTER_SPREAD_ENABLED
      if (numBullets == FIGHTER_MAX_BULLETS && spreadAmount < 2)
        spreadAmount++;
    #endif
  } 
  
  // Extra Shot
  else if ([powerup isKindOfClass:[ExtraShot class]]) 
  {
    score = POWERUP_WEAPON_SCORE;
    if (numShots < FIGHTER_MAX_SHOTS) {
      [self addExtraShot];
      [self postNotification:FighterExtraShotNotification];
    }
  }
  
  // Extra Life
  else if ([powerup isKindOfClass:[ExtraLife class]]) 
  {
    score = POWERUP_LIFE_SCORE;
    lives++;
    [self postNotification:FighterExtraLifeNotification];
  } 
  
  // Extra Health
  else if ([powerup isKindOfClass:[ExtraHealth class]]) 
  {
    score = POWERUP_HEALTH_SCORE;
    [self incrementHealth:1];
  } 
  
  [scene incrementScoreWithPulse:score];
  [[TESoundManager sharedManager] play:sound];
}

-(void)addExtraShot {
  numShots++;
  [shotTimers addObject:[[ShotTimer alloc] init]];
}


-(BOOL)hasCustomTransformation {
  return YES;
}

-(GLKMatrix4)customTransformation {
  return GLKMatrix4MakeYRotation(yRotation);
}

@end
