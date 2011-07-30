//
//  Asteroid.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

extern NSString *const AsteroidDestroyedNotification;// = @"asteroidDiedNotification";

@interface Asteroid : TECharacter {
  int hitPoints;
}

-(void)registerHit;
-(void)die;
-(void)explode;
-(BOOL)dead;

@end
