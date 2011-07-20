//
//  Bullet.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Bullet.h"
#import "TECharacterLoader.h"

@implementation Bullet

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"bullet"];
  }
  
  return self;
}

@end