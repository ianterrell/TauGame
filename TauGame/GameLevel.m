//
//  GameLevel.m
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameLevel.h"

@class Game;
@class TENode;

@implementation GameLevel

+(NSString *)name {
  return @"Unnamed";
}

+(TENode *)nameSpriteWithPointRatio:(float)pointRatio {
  UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
  TESprite *sprite = [[TESprite alloc] initWithImage:[TEImage imageFromText:[self name] withFont:font color:[UIColor whiteColor]] pointRatio:pointRatio];
  return [TENode nodeWithDrawable:sprite];
}

-(id)initWithGame:(Game*)_game {
  self = [super init];
  if (self) {
    game = _game;
  }
  return self;
}

-(void)update {
}

-(BOOL)done {
  return NO;
}

@end
