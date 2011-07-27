//
//  Asteroid.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface Asteroid : TECharacter {
  int hitPoints;
}

-(void)registerHit;
-(void)die;

@end
