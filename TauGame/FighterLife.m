//
//  FighterLife.m
//  TauGame
//
//  Created by Ian Terrell on 7/31/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "FighterLife.h"
#import "TauEngine.h"

@implementation FighterLife

- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"fighter-life"];
  }
  return self;
}

@end
