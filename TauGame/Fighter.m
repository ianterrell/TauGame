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

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"fighter"];
  }
  
  return self;
}

@end
