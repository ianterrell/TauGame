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

- (id)init
{
  self = [super init];
  if (self) {
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

-(float)radius {
  return 0.0;
}

@end
