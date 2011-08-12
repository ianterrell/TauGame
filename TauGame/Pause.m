//
//  Pause.m
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "Pause.h"
#import "Background.h"
#import "Starfield.h"
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
    clearColor = GLKVector4Make(0, 0, 0, 1);
    [characters addObject:[[Background alloc] initInScene:self]];
    [Starfield addDefaultStarfieldWithWidth:self.width height:self.height pixelRatio:POINT_RATIO toScene:self];
    
    GameButton *resume = [[GameButton alloc] initWithText:@"RESUME"];
    resume.object = self;
    resume.action = @selector(resume);
    resume.position = self.center;
    [self addButton:resume];
  }
  return self;
}

-(void)resume {
  [TEAccelerometer zero];
  [[GameController sharedController] displayScene:kTEPreviousScene duration:0.4 options:UIViewAnimationOptionTransitionFlipFromBottom completion:NULL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
