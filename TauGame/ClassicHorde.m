//
//  BaddieField.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "ClassicHorde.h"
#import "Baddie.h"
#import "Fighter.h"
#import "Bullet.h"
#import "SeekNShoot.h"

@implementation ClassicHorde

+(NSString *)name {
  return @"Invading Hordes";
}

-(id)initWithGame:(Game*)_game {
  self = [super initWithGame:_game];
  if (self) {
    for (int i = 0; i < 3*game.currentLevelNumber; i++)
      [self addRandomBaddie];
  }
  return self;
}

-(void)update {
}

-(BOOL)done {
  return [game.enemies count] == 0;
}

-(void)addRandomBaddie {
  Baddie *baddie = [[SeekNShoot alloc] init];
  
  float randX = [TERandom randomFraction] * game.visibleWidth + game.bottomLeftVisible.x;
  float randY = [TERandom randomFraction] * (game.visibleHeight - 3) + game.bottomLeftVisible.y + 3;
  
  baddie.position = GLKVector2Make(randX, randY);
  baddie.shape.color = GLKVector4Make([TERandom randomFractionFrom:0.5 to:1], [TERandom randomFractionFrom:0.5 to:1], [TERandom randomFractionFrom:0.5 to:1], 1.0);
  
  [game.characters addObject:baddie];
  [game.enemies addObject:baddie];
}

@end
