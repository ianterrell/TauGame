//
//  TENumberDisplay.h
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"

@interface TENumberDisplay : TENode {
  int number, numDigits, padDigit;
  float width, height;
}

@property int number, numDigits, padDigit;
@property float width, height;

@end
