//
//  MainMenuViewController.h
//  TauGame
//
//  Created by Ian Terrell on 7/22/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface TitleScreen : TEMenu <GKLeaderboardViewControllerDelegate>

-(void)credits;
-(void)leaderboard;
-(void)play;

@end
