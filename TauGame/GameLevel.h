//
//  GameLevel.h
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "Game.h"

@interface  GameLevel : NSObject {
  Game *game;
  BOOL recurseEnemiesForCollisions;
}

@property(strong,readonly) Game *game;
@property(readonly) BOOL recurseEnemiesForCollisions;

+(NSString *)name;
+(TENode *)nameSpriteWithPointRatio:(float)pointRatio;

-(id)initWithGame:(Game*)game;
-(void)update;
-(BOOL)done;

@end
