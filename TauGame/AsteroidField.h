//
//  AsteroidField.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"
#import "Fighter.h"

@interface AsteroidField : TEScene {
  Fighter *fighter;
}

-(void)setupCoordinateSystem;

@end
