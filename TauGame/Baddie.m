//
//  Baddie.m
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"
#import "TECharacterLoader.h"
#import "BaddieField.h"

@implementation Baddie

- (id)init
{
  self = [super init];
  if (self) {
    hitPoints = 3;
    [TECharacterLoader loadCharacter:self fromJSONFile:@"baddie"];
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self wraparoundInScene:scene];
}

// TODO update baddie field whenever it gets done
//-(void)onRemovalFromScene:(TEScene *)scene {
//  [((BaddieField *)scene).ships removeObject:self];
//  [(BaddieField *)scene addRandomBaddie];
//}

-(void)registerHit {
  [[TESoundManager sharedManager] play:@"hurt"];
  hitPoints--;
  
  TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:self];
  highlight.color = GLKVector4Make(1, 1, 1, 1);
  highlight.duration = 0.1;

  if (hitPoints == 0) {
    self.collide = NO;
    highlight.onRemoval = ^(){
      TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
      scaleAnimation.scale = 0.0;
      scaleAnimation.duration = 0.5;
      scaleAnimation.onRemoval= ^(){
        self.remove = YES;
      };
      [self.currentAnimations addObject:scaleAnimation];
      
      TERotateAnimation *rotateAnimation = [[TERotateAnimation alloc] init];
      rotateAnimation.rotation = [TERandom randomFraction] * 2 * M_TAU;
      rotateAnimation.duration = 0.5;
      [self.currentAnimations addObject:rotateAnimation];
    };
  }
  
  [self.currentAnimations addObject:highlight];
}

@end