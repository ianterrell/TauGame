//
//  BaddieField.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameLevel.h"

@interface ClassicHorde : GameLevel {
  int rows, columns;
}

@property(readonly) int rows, columns;

-(void)addHordeUnitAtRow:(int)row column:(int)col;

@end