//
//  MainMenuViewController.m
//  TauGame
//
//  Created by Ian Terrell on 7/22/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "GameButton.h"
#import "TitleScreen.h"
#import "Game.h"

@implementation TitleScreen

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
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:64];
    TESprite *title = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"GALAXY WILD" withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
    TENode *titleNode = [TENode nodeWithDrawable:title];
    titleNode.scaleX = 0.9;
    titleNode.scaleY = 0.5;
    titleNode.position = GLKVector2Make(self.width/2,self.height/2+0.5);
    [characters addObject:titleNode];
    
    TitleScreen *this = self;
    
    GameButton *credits = [[GameButton alloc] initWithText:@"INFO" font:[UIFont fontWithName:@"Helvetica-Bold" size:32] touchScale:GLKVector2Make(1.5, 5)];
    credits.action = ^() {
      [self credits];
    };
    credits.position = GLKVector2Make(self.left+1.25*0.75*((TESprite*)credits.shape).width/2, self.bottom + 1.25*0.5*((TESprite*)credits.shape).height/2);
    [self addButton:credits];
    
    leaderboardButton = [[GameButton alloc] initWithText:@"LEADERBOARD" font:[UIFont fontWithName:@"Helvetica-Bold" size:32] touchScale:GLKVector2Make(1.5, 5)];
    leaderboardButton.action = ^() {
      [this leaderboard];
    };
    leaderboardButton.position = GLKVector2Make(self.right-1.25*0.75*((TESprite*)leaderboardButton.shape).width/2, self.bottom + 1.25*0.5*((TESprite*)leaderboardButton.shape).height/2);
    if ([GameController canUseGameKit])
      [self addButton:leaderboardButton];
    
    if (![GameController upgraded]) {
      if ([SKPaymentQueue canMakePayments])
      {
        upgradeButton = [[GameButton alloc] initWithText:@"UPGRADE" font:[UIFont fontWithName:@"Helvetica-Bold" size:32] touchScale:GLKVector2Make(1.5, 5)];
        upgradeButton.action = ^() {
          [this upgrade];
        };
        upgradeButton.position = GLKVector2Make(self.right-1.25*0.75*((TESprite*)upgradeButton.shape).width/2, self.top - 1.25*0.5*((TESprite*)upgradeButton.shape).height/2);
        [self addButton:upgradeButton];
        
        restoreButton = [[GameButton alloc] initWithText:@"RESTORE" font:[UIFont fontWithName:@"Helvetica-Bold" size:32] touchScale:GLKVector2Make(1.5, 5)];
        restoreButton.action = ^() {
          [this restoreUpgrade];
        };
        restoreButton.position = GLKVector2Make(self.left+1.25*0.75*((TESprite*)restoreButton.shape).width/2, self.top - 1.25*0.5*((TESprite*)restoreButton.shape).height/2);
        [self addButton:restoreButton];
      }
      else
      {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ruh roh!" message:@"Upgrading to have multiple lives requires that in app purchases be enabled!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show]; 
      }
    }
    
    GameButton *play = [[GameButton alloc] initWithText:@"tap to play" font:[UIFont fontWithName:@"Helvetica" size:48] touchScale:GLKVector2Make(1.5, 5)];
    play.action = ^() {
      [self play];
    };
    play.position = GLKVector2Make(self.center.x, self.center.y - 1 + 0.5);
    [self addButton:play];
    
    TEScaleAnimation *animation = [[TEScaleAnimation alloc] init];
    animation.scale = 1.2;
    animation.duration = 0.5;
    animation.reverse = YES;
    animation.repeat = kTEAnimationRepeatForever;
    [play.currentAnimations addObject:animation];
  }
  
  return self;
}

-(void)credits {
  [[GameController sharedController] displayScene:@"credits"];
}

-(void)showLeaderboardButton {
  [self addButton:leaderboardButton];
}

-(void)hideLeaderboardButton {
  [self removeButton:leaderboardButton];
}

- (void)leaderboard
{
  if ([[GameController sharedController] usingGameCenter]) {
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
      leaderboardController.leaderboardDelegate = self;
      [self presentModalViewController: leaderboardController animated: YES];
    }
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ruh roh!" message:@"The leaderboard functionality requires you be logged into Game Center." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
  [self dismissModalViewControllerAnimated:YES];
}

-(void)play {
  [TEAccelerometer zero];
  [[GameController sharedController] addSceneOfClass:[Game class] named:@"game"];
  [[GameController sharedController] displayScene:@"game"];
}

-(void)upgrade {
  [[GameController sharedController] upgrade];
}

-(void)restoreUpgrade {
  [[GameController sharedController] restoreUpgrade];
}

-(void)removeUpgradeButtons {
  [self removeButton:restoreButton];
  [self removeButton:upgradeButton];
}

@end
