//
//  HordeUnit.h
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"
#import "ClassicHorde.h"

@interface HordeUnit : Baddie {
  int row, column;
  ClassicHorde *level;
  float shotDelayMin, shotDelayMax, shotDelay;
}

-(id)initWithLevel:(ClassicHorde*)level row:(int)row column:(int)column shotDelayMin:(float)min shotDelayMax:(float)max;

@end
