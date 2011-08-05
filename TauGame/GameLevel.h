//
//  GameLevel.h
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@class Game;

@interface  GameLevel : NSObject {
  Game *game;
}

@property(readonly) Game *game;

+(NSString *)name;
+(TENode *)nameSpriteWithPointRatio:(float)pointRatio;

-(id)initWithGame:(Game*)game;
-(void)update;
-(BOOL)done;

@end
