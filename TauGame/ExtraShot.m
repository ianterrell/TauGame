//
//  ExtraShot.m
//  TauGame
//
//  Created by Ian Terrell on 8/1/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "ExtraShot.h"

@implementation ExtraShot

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"extra-shot-powerup"];
    [self setInnerColor:GLKVector4Make(1,0.522,0.04,1) outerColor:GLKVector4Make(0.6, 0, 0, 1)];
  }
  
  return self;
}

@end
