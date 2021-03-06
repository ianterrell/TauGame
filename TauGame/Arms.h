//
//  Arms.h
//  TauGame
//
//  Created by Ian Terrell on 8/5/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"

@interface Arms : Baddie {
  int numShots, shooting;
  float shotInterval;
  
  GLKVector2 seekingLocation;
  float seekingDelay, seekingOffset;
  
  NSArray *appendages;
}

@property int numShots;
@property float seekingOffset;

-(NSArray*)appendageNames;
-(void)setupLegs;
-(void)seekInScene:(Game*)game;

@end
