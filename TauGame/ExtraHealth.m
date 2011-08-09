//
//  ExtraHealth.m
//  TauGame
//
//  Created by Ian Terrell on 8/9/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "ExtraHealth.h"

@implementation ExtraHealth

- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"extra-health-powerup"];
    [self setInnerColor:GLKVector4Make(0,1,1,1) outerColor:GLKVector4Make(1, 1, 1, 1)];
  }
  
  return self;
}

@end
