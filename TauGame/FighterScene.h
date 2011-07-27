//
//  FighterScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

#import "Bullet.h"

@class Fighter;

@interface FighterScene : TEScene {
  Fighter *fighter;
  NSMutableArray *bullets;

  TESoundManager *sounds;
}

@property(strong) Fighter *fighter;
@property(strong) NSMutableArray *bullets;

@end
