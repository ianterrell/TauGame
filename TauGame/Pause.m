//
//  Pause.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "Pause.h"
#import "GameButton.h"

@implementation Pause

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Set up coordinates
    CGSize parentSize = frame.size;
    [self setLeft:0 right:parentSize.height/POINT_RATIO bottom:0 top:parentSize.width/POINT_RATIO]; // not sure why container isn't sized properly
    
    // Set up background
    [[GameController sharedController] setupBackgroundIn:self];
    
    GameButton *resume = [[GameButton alloc] initWithText:@"CONTINUE"];
    resume.action = ^() {
      [self resume];
    };
    [self addButton:resume];
    
    GameButton *options = [[GameButton alloc] initWithText:@"OPTIONS"];
    options.action = ^() {
      [self options];
    };
    [self addButton:options];
    
    GameButton *quit = [[GameButton alloc] initWithText:@"QUIT"];
    quit.action = ^() {
      [self quit];
    };
    [self addButton:quit];
    
    int numButtons = [buttons count];
    for (int i = 0; i < numButtons; i++)
      ((TEButton*)[buttons objectAtIndex:i]).position = GLKVector2Make(self.center.x, self.top-(i+1)*self.height/(numButtons+1));
  }
  return self;
}

-(void)resume {
  [TEAccelerometer zero];
  [[GameController sharedController] displayScene:@"game" duration:0.4 options:UIViewAnimationOptionTransitionFlipFromBottom completion:NULL];
}

-(void)options {
  [[GameController sharedController] displayScene:@"options"];
}

-(void)quit {
  [[GameController sharedController] displayScene:@"menu" duration:1 options:(UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionCrossDissolve) completion:^(BOOL finished) {
    [[GameController sharedController] removeScene:@"game"];
  }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
