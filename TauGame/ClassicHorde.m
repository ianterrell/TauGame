//
//  BaddieField.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "ClassicHorde.h"
#import "Baddie.h"
#import "Fighter.h"
#import "Bullet.h"
#import "HordeUnit.h"

@implementation ClassicHorde

@synthesize rows, columns, bottoms;

+(NSString *)name {
  return @"Invading Hordes";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    rows = MIN(HORDE_MAX_ROWS,HORDE_INITIAL_ROWS + game.currentLevelNumber / HORDE_LEVELS_PER_ROW);
    columns = MIN(HORDE_MAX_COLS,HORDE_INITIAL_COLS + rows + game.currentLevelNumber % HORDE_LEVELS_PER_COL);
    
    bottoms = [NSMutableArray arrayWithCapacity:columns];
    
    for (int row = 0; row < rows; row++)
      for (int col = 0; col < columns; col++)
        [self addHordeUnitAtRow:row column:col];
  }
  return self;
}

-(void)addHordeUnitAtRow:(int)row column:(int)col {
  HordeUnit *baddie = [[HordeUnit alloc] initWithLevel:self row:row column:col];
  
  baddie.velocity = GLKVector2Make(HORDE_X_VELOCITY_INITIAL+HORDE_X_VELOCITY_LEVEL_FACTOR*game.currentLevelNumber,
                                   -1*(HORDE_Y_VELOCITY_INITIAL+HORDE_Y_VELOCITY_LEVEL_FACTOR*game.currentLevelNumber));
  
  baddie.maxVelocity = MIN(HORDE_MAX_VELOCITY_MAX,HORDE_MAX_VELOCITY_FACTOR*baddie.velocity.x);
  baddie.acceleration = GLKVector2Make(HORDE_X_ACCEL_LEVEL_FACTOR*game.currentLevelNumber,-1*HORDE_Y_ACCEL_LEVEL_FACTOR*game.currentLevelNumber);
  
  [baddie setupInGame:game];
  
  if (row == rows - 1)
    [bottoms addObject:baddie];
}

-(void)update {
  [[self class] updateRowsAndColumnsForLevel:self inGame:game];
}

+(void)enumerateHordeUnitsInGame:(Game*)game withBlock:(void (^)(HordeUnit *))block {
  [game.enemies enumerateObjectsUsingBlock:^(HordeUnit *baddie, NSUInteger idx, BOOL *stop) {
    if ([baddie isKindOfClass:[HordeUnit class]])
      block(baddie);
  }];
}

+(void)updateRowsAndColumnsForLevel:(id<GriddedGameLevel>)level inGame:(Game*)game {
  __block int minRow = level.rows, maxRow = 0, minColumn = level.columns, maxColumn = 0;
  [self enumerateHordeUnitsInGame:game withBlock:^(HordeUnit *baddie){
    minRow = MIN(minRow,baddie.row);
    maxRow = MAX(maxRow,baddie.row);
    minColumn = MIN(minColumn,baddie.column);
    maxColumn = MAX(maxColumn,baddie.column);
    
    HordeUnit *bottom = [level.bottoms objectAtIndex:baddie.column];
    if ([bottom dead] || baddie.row > bottom.row)
      [level.bottoms replaceObjectAtIndex:baddie.column withObject:baddie];
  }];
  
  int colDelta = level.columns - (maxColumn - minColumn + 1);
  if (colDelta > 0){
    level.columns -= colDelta;
    
    for (int i = 0; i < colDelta; i++)
      [level.bottoms removeObjectAtIndex:0];
    
    if (minColumn > 0)
      [self enumerateHordeUnitsInGame:game withBlock:^(HordeUnit *baddie){
        baddie.column -= minColumn;
      }];
  }
  
  int rowDelta = level.rows - (maxRow - minRow + 1);
  if (rowDelta > 0) {
    level.rows -= rowDelta;
    if (minRow > 0)
      [self enumerateHordeUnitsInGame:game withBlock:^(HordeUnit *baddie){
        baddie.row -= minRow;
        [baddie updateShotDelaysInLevel];
      }];
  }
}



@end
