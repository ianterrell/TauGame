//
//  Baddie.m
//  TauGame
//
//  Created by Ian Terrell on 7/21/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Baddie.h"
#import "TECharacterLoader.h"

@implementation Baddie

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"baddie"];
  }
  
  return self;
}


@end
