//
//  MainMenuViewController.h
//  TauGame
//
//  Created by Ian Terrell on 7/22/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "GameButton.h"

@interface TitleScreen : TEMenu <GKLeaderboardViewControllerDelegate> {
  GameButton *leaderboardButton, *restoreButton, *upgradeButton;
}

-(void)showLeaderboardButton;
-(void)hideLeaderboardButton;
-(void)credits;
-(void)leaderboard;
-(void)play;
-(void)upgrade;
-(void)restoreUpgrade;
-(void)removeUpgradeButtons;

@end
