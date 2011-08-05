//
//  GriddedGameLevel.h
//  TauGame
//
//  Created by Ian Terrell on 8/5/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@protocol GriddedGameLevel <NSObject>

@property(readonly) int rows, columns;
-(Game*)game;

@end
