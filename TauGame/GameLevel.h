//
//  GameLevel.h
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@protocol GameLevel <NSObject>

-(id)initWithGame:(Game*)game;
-(void)update;
-(BOOL)done;

@end
