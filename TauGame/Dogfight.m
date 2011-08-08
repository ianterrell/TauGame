//
//  Dogfight.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Dogfight.h"
#import "Baddie.h"
#import "Seeker.h"
#import "Arms.h"
#import "HordeUnit.h"
#import "Spinner.h"

#import "BigHordeUnit.h"
#import "BigArms.h"


#define NUM_ENEMIES 4

static Class enemyClasses[NUM_ENEMIES];

@implementation Dogfight

+(void)initialize {
  int i = 0;
  enemyClasses[i++] = [Seeker class];
  enemyClasses[i++] = [Arms class];
  enemyClasses[i++] = [HordeUnit class];
  enemyClasses[i++] = [Spinner class];
}

+(NSString *)name {
  return @"Dogfight";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    Baddie *baddie = [[BigArms alloc] init];
    baddie.position = GLKVector2Make([TERandom randomFractionFrom:game.left to:game.right],[TERandom randomFractionFrom:game.bottom+2 to:game.top-1]);    
    [game addCharacterAfterUpdate:baddie];
    [game.enemies addObject:baddie];
//    [game.enemyBullets addObject:baddie]; horde
    recurseEnemiesForCollisions = YES;
  }
  return self;
}

@end
