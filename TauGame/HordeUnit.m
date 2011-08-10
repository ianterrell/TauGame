//
//  HordeUnit.m
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "HordeUnit.h"
#import "GlowingBullet.h"
#import "Game.h"

#define COLUMN_WIDTH 1.2
#define ROW_HEIGHT 0.75

#define TOP_BUFFER 0.3
#define BOTTOM_BUFFER 1.5

#define HORDE_UNIT_NUM_COLORS 6

static float reds[]   = {1,0,0,1,0,1};
static float greens[] = {0,1,0,1,1,0};
static float blues[]  = {0,0,1,0,1,1};
static int colorIndex = 0;

@implementation HordeUnit

@synthesize row, column;

+(BaddieShootingStyle)shootingStyle {
  return kBaddieRandomShot;
}

+(BOOL)blinks {
  return YES;
}

+(void)randomlyColorizeUnit:(Baddie *)baddie {
  [self colorizeUnit:baddie index:[TERandom randomTo:HORDE_UNIT_NUM_COLORS]];
}

+(void)colorizeUnit:(Baddie *)baddie index:(int)index {
  baddie.shape.renderStyle = kTERenderStyleVertexColors;
  int j = [TERandom randomTo:4];
  int k = [TERandom randomTo:4];
  for (int i = 0; i < 4; i++) {
    float factor = (i == j || i == k) ? 0.95 : 0.5;
    baddie.shape.colorVertices[i] = GLKVector4Make(reds[index]*factor, greens[index]*factor, blues[index]*factor, 1.0);
  }
  baddie.shape.color = GLKVector4Make(reds[index], greens[index], blues[index], 1.0); // for bullets
}

-(id)initWithLevel:(id<GriddedGameLevel>)_level row:(int)_row column:(int)_column
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"horde-unit"];
    
    level = _level;
    row = _row;
    column = _column;
    self.hitPoints = 1;
    
    self.position = GLKVector2Make((column+1)*COLUMN_WIDTH, level.game.top-(row+1)*ROW_HEIGHT-TOP_BUFFER);
    
    [[self class] colorizeUnit:self index:(colorIndex++)%HORDE_UNIT_NUM_COLORS];
    
    [self updateShotDelaysInLevel];
    [self resetShotDelay];
  }
  
  return self;
}

// Maybe shouldn't be here, but what the hell
-(void)updateShotDelaysInLevel {
  self.shotDelayMin = MAX(HORDE_SHOT_DELAY_MIN_MIN,HORDE_SHOT_DELAY_MIN_INITIAL-HORDE_SHOT_DELAY_MIN_LEVEL_FACTOR*level.game.currentLevelNumber);
  self.shotDelayMax = MAX(HORDE_SHOT_DELAY_MAX_MIN,HORDE_SHOT_DELAY_MAX_INITIAL-HORDE_SHOT_DELAY_MAX_LEVEL_FACTOR*level.game.currentLevelNumber);
  [self resetShotDelay];
}

-(void)shootInScene:(Game *)scene {
  if (self == [level.bottoms objectAtIndex:self.column])
    [super shootInScene:scene];
  else
    [self resetShotDelay];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];

  [super bounceXInScene:scene bufferLeft:COLUMN_WIDTH*(column+1) bufferRight:COLUMN_WIDTH*(level.columns-column)];
  [super bounceYInScene:scene bufferTop:TOP_BUFFER+ROW_HEIGHT*(row+1) bufferBottom:BOTTOM_BUFFER+ROW_HEIGHT*(level.rows-row)];
}

@end
