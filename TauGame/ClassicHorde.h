//
//  BaddieField.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameLevel.h"

@interface ClassicHorde : NSObject <GameLevel> {
  Game *game;
}

-(void)addRandomBaddie;

@end
