//
//  Enemy.h
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

extern NSString *const EnemyDestroyedNotification;// = @"EnemyDestroyedNotification";

@interface Enemy : TENode {
  int hitPoints;
}

@property(readonly) int pointsPerHit, pointsForDestruction;

-(void)registerHit;
-(void)die;
-(void)explode;
-(BOOL)dead;

-(TEAnimation *)flashWhiteAnimation;
-(void)flashWhite;

@end
