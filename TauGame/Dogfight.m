//
//  Dogfight.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Dogfight.h"
#import "BiggunBag.h"
#import "BigHordeUnit.h"
#import "BigSpinner.h"

static BiggunBag *bag;

@implementation Dogfight

+(void)initialize {
  bag = [[BiggunBag alloc] init];
}

+(NSString *)name {
  return @"Dogfight";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    Baddie *baddie = [[[bag drawItem] alloc] init];
    baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],[TERandom randomFractionFrom:game.bottom+2 to:game.top-1]);    

    [game addCharacterAfterUpdate:baddie];
    [game.enemies addObject:baddie];
    
    if ([baddie isKindOfClass:[BigHordeUnit class]])
      [game.enemyBullets addObject:baddie];
    else if ([baddie isKindOfClass:[BigSpinner class]]) {
      BigSpinner *spinner = (BigSpinner*)baddie;
      [game addCharacterAfterUpdate:spinner.leftSlave];
      [game.enemies addObject:spinner.leftSlave];
      [game addCharacterAfterUpdate:spinner.rightSlave];
      [game.enemies addObject:spinner.rightSlave];
    }
    
    recurseEnemiesForCollisions = YES;
  }
  return self;
}

@end
