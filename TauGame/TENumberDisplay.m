//
//  TENumberDisplay.m
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENumberDisplay.h"
#import "TEDigit.h"

@implementation TENumberDisplay

@synthesize number, numDigits, padDigit, width, height;

- (id)init
{
  self = [super init];
  if (self) {
    number = numDigits = padDigit = width = height = 0;
    TEDigit *digit = [[TEDigit alloc] init];
    digit.node = self;
    digit.width = 1;
    digit.height = 1;
    
    self.drawable = digit;
  }
  
  return self;
}

@end
