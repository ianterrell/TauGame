//
//  ExtraLife.m
//  TauGame
//
//  Created by Ian Terrell on 8/1/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "ExtraLife.h"

@implementation ExtraLife

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"extra-life-powerup"];
    [self setInnerColor:GLKVector4Make(0,0.8,0.8,1) outerColor:GLKVector4Make(0, 0, 0.6, 1)];
  }
  
  return self;
}

@end
