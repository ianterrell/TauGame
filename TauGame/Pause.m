//
//  Pause.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "Pause.h"

@implementation Pause

-(id)initWithFrame:(CGRect)frame {
  return [super init];
}

-(void)resume {
  [TEAccelerometer zero];
  [[GameController sharedController] displayScene:kTEPreviousScene duration:0.4 options:UIViewAnimationOptionTransitionFlipFromBottom completion:NULL];
}

- (void)loadView
{
  CGSize parentSize = [GameController sharedController].container.frame.size;
  UIView *view = [[UIView alloc] initWithFrame:[GameController sharedController].container.frame];
  self.view = view;
  
  UIButton *resumeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [resumeButton setTitle:@"RESUME" forState:UIControlStateNormal];
  resumeButton.frame = CGRectMake(0,0,150,50);
  resumeButton.center = CGPointMake(parentSize.width/2, parentSize.height/2);
  resumeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
  [resumeButton addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:resumeButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
