//
//  Enemy.m
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Enemy.h"

NSString *const EnemyDestroyedNotification = @"EnemyDestroyedNotification";

@implementation Enemy

+(void)initialize {
  [[TESoundManager sharedManager] load:@"explosion"];
}

- (id)init
{
  self = [super init];
  if (self) {
    self.collide = YES;
    hitPoints = 1;
  }
  
  return self;
}

-(int)pointsPerHit {
  return 1;
}

-(int)pointsForDestruction {
  return 10;
}

-(void)registerHit {
  [[TESoundManager sharedManager] play:@"hurt2"];
  [self flashWhite];
  
  hitPoints--;
  if ([self dead])
    [self die];
}

-(void)die {
  [self postNotification:EnemyDestroyedNotification];
  [[TESoundManager sharedManager] play:@"explosion"];
  [self explode];
}

-(void)explode {
  self.collide = NO;
  self.remove = YES;
}

-(BOOL)dead {
  return hitPoints <= 0;
}

-(TEAnimation *)flashWhiteAnimation {
  TEAnimation *highlight;
  if ((self.shape.renderStyle & kTERenderStyleVertexColors) == kTERenderStyleVertexColors) {
    highlight = [[TEVertexColorAnimation alloc] initWithNode:self];
    for (int i = 0; i < self.shape.numVertices; i++)
      ((TEVertexColorAnimation*)highlight).toColorVertices[i] = GLKVector4Make(1, 1, 1, 1);
  } else {
    highlight = [[TEColorAnimation alloc] init];
    ((TEColorAnimation*)highlight).color = GLKVector4Make(1, 1, 1, 1);
  }
  highlight.duration = 0.2;
  highlight.backward = YES;
  return highlight;
}

-(void)flashWhite {
  [self startAnimation:[self flashWhiteAnimation]];
}

@end
