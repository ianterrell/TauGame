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
    
    // Set up motion
    attitude = [[TEAdjustedAttitude alloc] init];
    [attitude zero];
  }
  
  return self;
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  [self wraparoundXInScene:scene];
  
  [attitude update];
  self.velocity = GLKVector2Make(30*attitude.roll, 0);
}

@end
