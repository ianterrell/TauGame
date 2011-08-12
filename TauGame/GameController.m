//
//  GameController.m
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"

@implementation GameController

-(id)init {
  self = [super init];
  if (self) {
    // Set up music
    NSError *error;
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Slipped" ofType:@"mp3"];
    NSURL *songURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:songURL error:&error];
    if (error)
      NSLog(@"Error loading audio player: %@", error);
    
    audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 1;
  }
  return self;
}

# pragma mark The Controller

+(GameController *)sharedController {
  static GameController *singleton;
  
  @synchronized(self) {
    if (!singleton)
      singleton = [[GameController alloc] init];
    return singleton;
  }
}

-(void)playMusic {
  [audioPlayer prepareToPlay];
  if (![audioPlayer play])
    NSLog(@"Error: Could not play music.");
}



@end
