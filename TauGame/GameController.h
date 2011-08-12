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
}

# pragma mark - The Controller

+(GameController *)sharedController;

# pragma mark - Music

-(void)playMusic;

@end
