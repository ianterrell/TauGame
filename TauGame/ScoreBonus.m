//
//  ScoreBonus.m
//  TauGame
//
//  Created by Ian Terrell on 8/9/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "ScoreBonus.h"

@implementation ScoreBonus

+(void)initialize {
  [[TESoundManager sharedManager] load:@"score-bonus"];
}

- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"score-bonus"];
  }
  
  return self;
}

@end
