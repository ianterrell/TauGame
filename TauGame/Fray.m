//
//  Fray.m
//  TauGame
//
//  Created by Ian Terrell on 8/5/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Fray.h"
#import "Seeker.h"

@implementation Fray

+(NSString *)name {
  return @"Into the Fray";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    Seeker *baddie = [[Seeker alloc] init];
    baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],game.height/2);
    [game addCharacterAfterUpdate:baddie];
    [game.enemies addObject:baddie];
  }
  return self;
}

@end
