//
//  HordeUnit.m
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "HordeUnit.h"
#import "Bullet.h"
#import "Game.h"

#define COLUMN_WIDTH 1.2
#define ROW_HEIGHT 0.75

#define TOP_BUFFER 0.3
#define BOTTOM_BUFFER 1.5

@implementation HordeUnit

-(void)resetShotDelay {
  shotDelay = [TERandom randomFractionFrom:shotDelayMin to:shotDelayMax];
}

-(id)initWithLevel:(ClassicHorde*)_level row:(int)_row column:(int)_column shotDelayMin:(float)min shotDelayMax:(float)max
{
  self = [super init];
  if (self) {
    level = _level;
    row = _row;
    column = _column;
    shotDelayMin = min;
    shotDelayMax = max;
    
    self.position = GLKVector2Make((column+1)*COLUMN_WIDTH, level.game.top-(row+1)*ROW_HEIGHT-TOP_BUFFER);
    
    float reds[]   = {1,0,0,1,0};
    float greens[] = {0,1,0,1,1};
    float blues[]  = {0,0,1,0,1};
    self.shape.color = GLKVector4Make(reds[column%5], greens[column%5], blues[column%5], 1.0);
    
    [self resetShotDelay];
  }
  
  return self;
}

-(void)shootInScene:(Game *)scene {
  // Can't shoot if dead!
  if ([self dead])
    return;
  
  [self resetShotDelay];
  
  [[TESoundManager sharedManager] play:@"shoot"];
  TECharacter *bullet = [[Bullet alloc] init];
  
  float x = self.position.x;
  float y = self.position.y - 1;
  bullet.position = GLKVector2Make(x, y);  
  bullet.velocity = GLKVector2Make(0, -5);
  bullet.shape.color = self.shape.color;
  [scene addCharacterAfterUpdate:bullet];
  [scene.enemyBullets addObject:bullet];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  if (shotDelay > 0)
    shotDelay -= dt;
  
  if (shotDelay <= 0)
    [self shootInScene:(Game*)scene];
  
  [super bounceXInScene:scene bufferLeft:COLUMN_WIDTH*(column+1) bufferRight:COLUMN_WIDTH*(level.columns-column)];
  [super bounceYInScene:scene bufferTop:TOP_BUFFER+ROW_HEIGHT*(row+1) bufferBottom:BOTTOM_BUFFER+ROW_HEIGHT*(level.rows-row)];
}

@end