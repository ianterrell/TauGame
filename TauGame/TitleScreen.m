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
    [self setLeft:0 right:parentSize.height/POINT_RATIO bottom:0 top:parentSize.width/POINT_RATIO]; // not sure why container isn't sized properly
    
    // Set up background
    [[GameController sharedController] setupBackgroundIn:self];
        
//    layer = [[StarfieldLayer alloc] initWithWidth:self.width height:self.height pixelRatio:POINT_RATIO numStars:500];
//    layer.position = GLKVector2Make(0,0);
//    [characters insertObject:layer atIndex:0];
//    
//    layer = [[StarfieldLayer alloc] initWithWidth:self.width height:self.height pixelRatio:POINT_RATIO numStars:500];
//    layer.position = GLKVector2Make(0,0);
//    [characters insertObject:layer atIndex:0];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:64];
    TESprite *title = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"GALAXY WILD" withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
    TENode *titleNode = [TENode nodeWithDrawable:title];
    titleNode.scaleX = 0.9;
    titleNode.scaleY = 0.5;
    titleNode.position = GLKVector2Make(self.width/2,self.height/2+0.5);
    [characters addObject:titleNode];
    
    GameButton *credits = [[GameButton alloc] initWithText:@"CREDITS" font:[UIFont fontWithName:@"Helvetica-Bold" size:32]];
    credits.action = ^() {
      [self credits];
    };
    credits.position = GLKVector2Make(self.left+1.25*0.75*((TESprite*)credits.shape).width/2, self.bottom + 1.25*0.5*((TESprite*)credits.shape).height/2);
    [self addButton:credits];
    
    leaderboardButton = [[GameButton alloc] initWithText:@"LEADERBOARD" font:[UIFont fontWithName:@"Helvetica-Bold" size:32]];
    TitleScreen *this = self;
    leaderboardButton.action = ^() {
      [this leaderboard];
    };
    leaderboardButton.position = GLKVector2Make(self.right-1.25*0.75*((TESprite*)leaderboardButton.shape).width/2, self.bottom + 1.25*0.5*((TESprite*)leaderboardButton.shape).height/2);
    
    if (![GameController upgraded]) {
      if ([SKPaymentQueue canMakePayments])
      {
        GameButton *upgrade = [[GameButton alloc] initWithText:@"UPGRADE" font:[UIFont fontWithName:@"Helvetica-Bold" size:32]];
        upgrade.action = ^() {
          [self upgrade];
        };
        upgrade.position = GLKVector2Make(self.right-1.25*0.75*((TESprite*)upgrade.shape).width/2, self.top - 1.25*0.5*((TESprite*)upgrade.shape).height/2);
        [self addButton:upgrade];
        
        GameButton *restoreUpgrade = [[GameButton alloc] initWithText:@"RESTORE" font:[UIFont fontWithName:@"Helvetica-Bold" size:32]];
        restoreUpgrade.action = ^() {
          [self restoreUpgrade];
        };
        restoreUpgrade.position = GLKVector2Make(self.left+1.25*0.75*((TESprite*)restoreUpgrade.shape).width/2, self.top - 1.25*0.5*((TESprite*)restoreUpgrade.shape).height/2);
        [self addButton:restoreUpgrade];
      }
      else
      {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ruh roh!" message:@"Upgrading to have multiple lives requires that in app purchases be enabled!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show]; 
      }
    }
    
    GameButton *play = [[GameButton alloc] initWithText:@"tap to play" font:[UIFont fontWithName:@"Helvetica" size:48]];
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

@end
