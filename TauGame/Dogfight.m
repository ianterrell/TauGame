//
//  Dogfight.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Dogfight.h"
#import "BiggunBag.h"
#import "Baddie.h"

static BiggunBag *biggunBag;

@implementation Dogfight

+(void)initialize {
  biggunBag = [[BiggunBag alloc] init];
}

+(NSString *)name {
  return @"Dogfight";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    Baddie *baddie = [[[biggunBag drawItem] alloc] init];
    baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],[TERandom randomFractionFrom:game.bottom+2 to:game.top-1]);    

    [baddie setupInGame:game];
    
    recurseEnemiesForCollisions = YES;
  }
  return self;
}

@end
