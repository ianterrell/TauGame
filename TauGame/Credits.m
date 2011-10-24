//
//  Credits.m
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "GameButton.h"
#import "Credits.h"
#import <UIKit/UIKit.h>

@implementation Credits
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Set up coordinates
    CGSize parentSize = frame.size;
    float extraScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
    [self setLeft:0 right:parentSize.height/(extraScale*POINT_RATIO) bottom:0 top:parentSize.width/(extraScale*POINT_RATIO)]; // not sure why container isn't sized properly
    
    // Set up background
//    clearColor = GLKVector4Make(0,0,0,1);
    [[GameController sharedController] setupBackgroundIn:self];
    
    GameButton *back = [[GameButton alloc] initWithText:@"BACK" touchScale:GLKVector2Make(2, 3)];
    
    float backHeight = ((TESprite*)back.drawable).height;
    
    back.action = ^() {
      [self back];
    };
    back.position = GLKVector2Make(self.center.x, self.bottom + backHeight/2);
    [self addButton:back];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20,20,parentSize.height-40,parentSize.width-100)];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    textView.textColor = [UIColor whiteColor];
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.text = @"Tap to shoot, tap in the upper right to pause.\n\nCrafted by Ian Terrell in Richmond, Virginia. Feel free to email me at ian.terrell@gmail.com.\n\nThe music is \"Slipped\" by Matt McFarland, used with his generous Creative Commons license.\nwww.mattmcfarland.com";
    [self.view addSubview:textView];
  }
  return self;
}

-(void)back {
  [[GameController sharedController] displayScene:kTEPreviousScene];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
