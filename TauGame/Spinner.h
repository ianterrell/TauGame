//
//  Spinner.h
//  TauGame
//
//  Created by Ian Terrell on 8/7/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"

@interface Spinner : Baddie {
  float accelerationFactor;
  BOOL slave;
}

@property float accelerationFactor;
@property BOOL slave;

@end
