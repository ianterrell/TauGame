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
    float extraScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
    [self setLeft:0 right:parentSize.height/(extraScale*POINT_RATIO) bottom:0 top:parentSize.width/(extraScale*POINT_RATIO)]; // not sure why container isn't sized properly
    
    // Set up background
    [[GameController sharedController] setupBackgroundIn:self];
    
    GameButton *resume = [[GameButton alloc] initWithText:@"CONTINUE" touchScale:GLKVector2Make(2, 2)];
    resume.action = ^() {
      [self resume];
    };
    [self addButton:resume];
    
    if (![GameController upgraded]) {
      GameButton *upgrade = [[GameButton alloc] initWithText:@"UPGRADE GAME" touchScale:GLKVector2Make(2, 2)];
      upgrade.action = ^() {
        [self upgrade];
      };
      [self addButton:upgrade];
    }
    
    GameButton *quit = [[GameButton alloc] initWithText:@"QUIT" touchScale:GLKVector2Make(2, 2)];
    quit.action = ^() {
      [self quit];
    };
    [self addButton:quit];
    
    float buffer = 2;
    int numButtons = [buttons count];
    for (int i = 0; i < numButtons; i++)
      ((TEButton*)[buttons objectAtIndex:i]).position = GLKVector2Make(self.center.x, self.top-buffer/2-(i+1)*(self.height-buffer)/(numButtons+1));
  }
  return self;
}

-(void)upgrade {
  [[GameController sharedController] upgrade];
}

-(void)resume {
  [TEAccelerometer zero];
  [[GameController sharedController] displayScene:@"game" duration:0.4 options:UIViewAnimationOptionTransitionFlipFromBottom completion:NULL];
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
