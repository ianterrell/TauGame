//
//  Baddie.h
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Enemy.h"

@interface Baddie : Enemy {
  float blinkDelay;
}

-(void)updateBlink:(NSTimeInterval)dt;
-(void)blink;

@end
