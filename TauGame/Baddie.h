//
//  Baddie.h
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECharacter.h"

extern NSString *const BaddieDestroyedNotification;

@interface Baddie : TECharacter {
  int hitPoints;
}

-(void)registerHit;

@end
