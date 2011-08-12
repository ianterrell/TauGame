//
//  Options.m
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Options.h"
#import "GameButton.h"
#import "GameController.h"

@implementation Options

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Set up coordinates
    CGSize parentSize = frame.size;
    [self setLeft:0 right:parentSize.height/POINT_RATIO bottom:0 top:parentSize.width/POINT_RATIO]; // not sure why container isn't sized properly
    
    // Set up background
    [[GameController sharedController] setupBackgroundIn:self];
    
    GameButton *back = [[GameButton alloc] initWithText:@"BACK"];
    back.action = ^() {
      [self back];
    };
    back.position = self.center;
    [self addButton:back];
  }
  return self;
}

-(void)back {
  [[GameController sharedController] displayScene:kTEPreviousScene];
}

@end
