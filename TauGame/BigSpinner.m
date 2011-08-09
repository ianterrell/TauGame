//
//  BigSpinner.m
//  TauGame
//
//  Created by Ian Terrell on 8/9/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "BigSpinner.h"

@implementation BigSpinner

@synthesize leftSlave, rightSlave;

- (id)init
{
  self = [super init];
  if (self) {
    self.scale = 0.65;
    
    leftSlave = [[Spinner alloc] init];
    leftSlave.scale = 0.4;
    leftSlave.slave = YES;
    leftSlave.hitPoints = 1;
    
    rightSlave = [[Spinner alloc] init];
    rightSlave.scale = 0.4;
    rightSlave.slave = YES;
    rightSlave.hitPoints = 1;
    
    [self resetShotDelay];
  }
  
  return self;
}

-(float)bounceBufferLeft {
  return [leftSlave dead] ? 0.65 : 1.5;
}

-(float)bounceBufferRight {
  return [rightSlave dead] ? 0.65 : 1.5;
}

-(void)setPosition:(GLKVector2)_position {
  [super setPosition:_position];
  leftSlave.position  = GLKVector2Make(position.x-1.1, position.y);
  rightSlave.position = GLKVector2Make(position.x+1.1, position.y);
}

-(void)registerHit {
  if ([leftSlave dead] && [rightSlave dead])
    [super registerHit];
  else
    [[TESoundManager sharedManager] play:@"hurt2"]; // TODO: invulnerable sound
}

@end
