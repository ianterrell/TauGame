//
//  GameController.h
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TESceneController.h"
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface GameController : TESceneController {
  AVAudioPlayer *audioPlayer;
  GKLocalPlayer *localPlayer;
  
  int highScore, highLevel;
}

@property(strong) GKLocalPlayer *localPlayer;
@property int highScore, highLevel;

# pragma mark - The Controller

+(GameController *)sharedController;

# pragma mark - Music

-(void)playMusic;

# pragma mark - GameKit

+(BOOL)canUseGameKit;
+(void)neverUseGameKit;

-(void)setupGameKit;
-(BOOL)usingGameCenter;

# pragma mark - Common Scene Stuff

-(void)setupBackgroundIn:(TEScene*)scene;

@end
