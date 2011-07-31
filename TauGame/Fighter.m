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
#define TURN_FACTOR 5

static GLKVector4 healthyColor, unhealthyColor;

@implementation Fighter

+(void)initialize {
  [[TESoundManager sharedManager] load:@"fighter-hurt"];
  [[TESoundManager sharedManager] load:@"shoot"];
  
  healthyColor = GLKVector4Make(0.188,0.761,0.0,1.0);
  unhealthyColor = GLKVector4Make(0.9,0.9,0.9,1.0);
}

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"fighter"];
    
    // Set up lives
    lives = 3;
    
    // Set up health
    health = maxHealth = 3;
    healthShapes = [self childrenNamed:[NSArray arrayWithObjects:@"health0", @"health1", @"health2", nil]];
    
    // Set up guns
    numBullets = 1;
    spreadAmount = 0;
    
    paused = NO;
    
    self.maxVelocity = MAX_VELOCITY;
    yRotation = 0.0;
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self wraparoundXInScene:scene];
  
  if (!paused) {
    self.velocity = GLKVector2Make(ACCELEROMETER_SENSITIVITY*[TEAccelerometer horizontal], 0);
    yRotation = MIN(1,MAX(-1,self.velocity.x / TURN_FACTOR)) * 1.0/6*M_TAU;
  }
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

-(BOOL)dead {
  return health <= 0;
}

-(BOOL)gameOver {
  return [self dead] && lives <= 0;
}

-(void)setHealth:(int)_health {
  health = _health;
  
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

-(void)explode {
  lives--;
  BOOL resurrect = ![self gameOver];
  
  collide = NO;
  paused = YES;
  
  __block BOOL setCallback = NO;
  [self traverseUsingBlock:^(TENode *node){
    TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
    rotateAnimation.rotation = [TERandom randomFractionFrom:-2 to:2] * M_TAU;
    rotateAnimation.duration = 1.5;
    rotateAnimation.reverse = resurrect;
    [node.currentAnimations addObject:rotateAnimation];
    
    TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
    translateAnimation.translation = GLKVector2Make([TERandom randomFractionFrom:-3 to:3], [TERandom randomFractionFrom:-3 to:3]);
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
        }
        else
          remove = YES;
      };
      setCallback = YES;
    }
    
    [node.currentAnimations addObject:scaleAnimation];
    [node markModelViewMatrixDirty];
  }];
}

-(void)registerHit {
  [[TESoundManager sharedManager] play:@"fighter-hurt"];
  [self decrementHealth:1];
  
  if ([self dead]) {
    [self explode];
  } else {
    collide = NO;
    
    TEColorAnimation *transparent = [[TEColorAnimation alloc] initWithNode:self];
    transparent.color = GLKVector4Make(1, 1, 1, 0.6);
    transparent.duration = 0.25;
    transparent.reverse = YES;
    transparent.repeat = 1;
    transparent.onRemoval = ^(){
      collide = YES;
    };
    
    TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
    highlight.color = GLKVector4Make(1, 0, 0, 1);
    highlight.duration = 0.1;
    highlight.reverse = YES;
    highlight.next = transparent;
    [self.currentAnimations addObject:highlight];
  }
}


-(void)getPowerup:(Powerup *)powerup {
  [[TESoundManager sharedManager] play:@"powerup"];
  
  if (numBullets < MAX_BULLETS)
    numBullets++;
  
  if (numBullets == MAX_BULLETS && spreadAmount < 2)
    spreadAmount++;
}

-(BOOL)hasCustomTransformation {
  return YES;
}

-(GLKMatrix4)customTransformation {
  return GLKMatrix4MakeYRotation(yRotation);
}

@end
