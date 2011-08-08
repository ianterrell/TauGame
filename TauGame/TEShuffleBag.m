//
//  TEShuffleBag.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TEShuffleBag.h"
#import "TERandom.h"

@implementation TEShuffleBag

-(id)init {
  self = [super init];
  if (self) {
    if ([self respondsToSelector:@selector(reset)])
      [self performSelector:@selector(reset)];
  }
  
  return self;
}

-(id)initWithItems:(NSArray *)items {
  self = [super init];
  if (self) {
    [self setItems:items];
  }
  
  return self;
}

-(void)setItems:(NSArray *)items {
  bag = [items mutableCopy];
}

-(id)drawItem {
  int i = [TERandom randomTo:[bag count]];
  id item = [bag objectAtIndex:i];
  [bag removeObjectAtIndex:i];
  
  if ([self respondsToSelector:@selector(reset)] && [bag count] == 0)
    [self performSelector:@selector(reset)];
  
  return item;
}

@end
