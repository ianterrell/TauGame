//
//  LevelBag.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "LevelBag.h"

#import "AsteroidField.h"
#import "ClassicHorde.h"
#import "Fray.h"
#import "Dogfight.h"

@implementation LevelBag

-(id)init {
  self = [super initWithItems:[NSArray arrayWithObjects:[AsteroidField class], [ClassicHorde class], [Fray class], [Dogfight class], nil] autoReset:YES];
  return self;
}

#ifdef DEBUG_LEVEL
-(id)drawItem {
  return DEBUG_LEVEL;
}
#endif

@end
