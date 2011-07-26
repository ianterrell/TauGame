//
//  BaddieField.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "FighterScene.h"

#import "Baddie.h"

@interface BaddieField : FighterScene {
  NSMutableArray *ships;
}

@property(strong) NSMutableArray *ships;

-(void)addRandomBaddie;

@end
