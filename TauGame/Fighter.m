//
//  Fighter.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Fighter.h"
#import "TECharacterLoader.h"

@implementation Fighter

+(void)initialize {
  [[TESoundManager sharedManager] load:@"fighter-hurt"];
  [[TESoundManager sharedManager] load:@"shoot"];
}

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"fighter"];
    
    // Set up motion
    attitude = [[TEAdjustedAttitude alloc] init];
    [attitude zero];
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self wraparoundXInScene:scene];
  
  [attitude update];
  self.velocity = GLKVector2Make(30*attitude.roll, 0);
}

-(void)shootInScene:(FighterScene *)scene {
  [[TESoundManager sharedManager] play:@"shoot"];
  
  TECharacter *bullet = [[Bullet alloc] init];
  bullet.position = GLKVector2Make(self.position.x, self.position.y + 1.1);
  bullet.velocity = GLKVector2Make(0, 5);
  [scene.characters addObject:bullet];
  [scene.bullets addObject:bullet];
}

-(void)registerHit {
  [[TESoundManager sharedManager] play:@"fighter-hurt"];
  
  TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
  highlight.color = GLKVector4Make(1, 0, 0, 1);
  highlight.duration = 0.1;
  [self.currentAnimations addObject:highlight];
}

@end
