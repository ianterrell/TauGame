//
//  SeekNShoot.h
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"

@interface Seeker : Baddie {
  float accelerationFactor, distanceToFighter, distanceToShoot;
}

@property float accelerationFactor, distanceToShoot;

@end
