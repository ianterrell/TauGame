//
//  Bullet.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Bullet.h"
#import "TECharacterLoader.h"
#import "BaddieField.h"

@implementation Bullet

+(void)initialize {
  [[TESoundManager sharedManager] load:@"hurt"];
}

- (id)init {
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"bullet"];
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self removeOutOfScene:scene buffer:1.0];
}

-(void)onRemovalFromScene:(TEScene *)scene {
  [((BaddieField *)scene).bullets removeObject:self];
}

@end
