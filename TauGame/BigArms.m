//
//  BigArms.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "BigArms.h"

@implementation BigArms

+(BOOL)blinks {
  return YES;
}

- (id)init
{
  self = [super init];
  if (self) {
    self.scale = 2;
    [self resetShotDelay];
  }
  
  return self;
}

-(NSArray *)appendageNames {
  return [NSArray arrayWithObjects:@"left arm", @"right arm", @"left leg", @"right leg",nil];
}

-(NSArray *)namesOfNodesToFlash {
  return [NSArray arrayWithObjects:@"body", @"left arm", @"right arm", @"left leg", @"right leg",nil];
}

-(void)setupLegs {
  [children exchangeObjectAtIndex:0 withObjectAtIndex:[children indexOfObject:[self childNamed:@"legs"]]];
}

@end
