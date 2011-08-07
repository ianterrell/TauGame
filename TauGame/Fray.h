//
//  Fray.h
//  TauGame
//
//  Created by Ian Terrell on 8/5/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameLevel.h"
#import "GriddedGameLevel.h"

@interface Fray : GameLevel<GriddedGameLevel> {
  int rows, columns;
}

@property(readonly) int rows, columns;

@end