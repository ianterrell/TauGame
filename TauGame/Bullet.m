//
//  Bullet.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

+(void)initialize {
  [[TESoundManager sharedManager] load:@"hurt"];
  [[TESoundManager sharedManager] load:@"hurt2"];
}

-(id)initWithColor:(GLKVector4)color {
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"bullet"];
    self.shape.color = color;
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self removeOutOfScene:scene buffer:1.0];
}

@end
