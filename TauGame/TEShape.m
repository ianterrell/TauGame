//
//  TEShape.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"
#import "TEEllipse.h"

@implementation TEShape

@synthesize color;

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

-(void)updateVertices {
}

-(BOOL)isPolygon {
  return ![self isCircle];
}

-(BOOL)isCircle {
  return [self isKindOfClass:[TEEllipse class]];
}

@end
