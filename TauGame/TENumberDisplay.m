//
//  TENumberDisplay.m
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENumberDisplay.h"

@implementation TENumberDisplay

@synthesize number, numDigits, padDigit, width, height;

- (id)init
{
  self = [super init];
  if (self) {
    number = numDigits = padDigit = width = height = 0;
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  
}

@end
