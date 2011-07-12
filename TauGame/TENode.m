//
//  TENode.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"

@implementation TENode

@synthesize name, shape, children;

- (id)init
{
  self = [super init];
  if (self) {
    self.children = [[NSMutableArray alloc] init];
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene {
  [super renderInScene:scene];
  
  [shape renderInScene:scene];
  [children makeObjectsPerformSelector:@selector(renderInScene:) withObject:scene];
}

# pragma mark Tree Methods

-(void)addChild:(TENode *)child {
  child.parent = self;
  [self.children addObject:child];
}

@end
