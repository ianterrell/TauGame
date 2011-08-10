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

@synthesize rows, columns;

+(NSString *)name {
  return @"Invading Hordes";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    rows = MIN(6,1 + game.currentLevelNumber / 5);
    columns = MIN(8,2 + rows + game.currentLevelNumber % 5);
    
    for (int row = 0; row < rows; row++)
      for (int col = 0; col < columns; col++)
        [self addHordeUnitAtRow:row column:col];
  }
  return self;
}

-(void)addHordeUnitAtRow:(int)row column:(int)col {
  HordeUnit *baddie = [[HordeUnit alloc] initWithLevel:self row:row column:col shotDelayMin:MAX(0.5,(1.5-game.currentLevelNumber/10.0)) shotDelayMax:MAX(1.5,(5.5-game.currentLevelNumber/10.0))];
  
  baddie.maxVelocity = 3*(0.5+game.currentLevelNumber/10.0);
  baddie.velocity = GLKVector2Make(0.5+game.currentLevelNumber/10.0,-0.01+game.currentLevelNumber/100.0);
  baddie.acceleration = GLKVector2Make(game.currentLevelNumber/200.0,-1*game.currentLevelNumber/400.0);
  
  [baddie setupInGame:game];
}

-(void)update {
  [[self class] updateRowsAndColumnsForLevel:self inGame:game];
}

+(void)enumerateHordeUnitsInGame:(Game*)game withBlock:(void (^)(HordeUnit *))block {
  [game.enemies enumerateObjectsUsingBlock:^(HordeUnit *baddie, NSUInteger idx, BOOL *stop) {
    if (![baddie isKindOfClass:[HordeUnit class]])
      return;
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
  }];
  
  int colDelta = level.columns - (maxColumn - minColumn + 1);
  if (colDelta > 0){
    level.columns -= colDelta;
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
      }];
  }
}



@end
