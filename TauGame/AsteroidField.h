//
//  AsteroidField.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"
#import "Fighter.h"
#import "TauEngine.h"

@interface AsteroidField : TEScene {
  Fighter *fighter;
  TEAdjustedAttitude *attitude;
}

@end
