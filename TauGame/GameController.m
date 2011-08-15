//
//  GameController.m
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "TitleScreen.h"
#import "Background.h"
#import "Starfield.h"

@implementation GameController

@synthesize localPlayer, highScore, highLevel;

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
    
    highScore = highLevel = 0;
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

# pragma mark - Music

-(void)playMusic {
  [audioPlayer prepareToPlay];
  if (![audioPlayer play])
    NSLog(@"Error: Could not play music.");
}

# pragma mark - GameKit

+(BOOL)canUseGameKit {
  // TODO: Check if file flag exists for never try again
  return YES;
}

+(void)neverUseGameKit {
  // TODO: Set file flag for never try again
}

-(void)fetchScoreForCategory:(NSString *)category callback:(void (^)(int value))block {
  GKLeaderboard *query = [[GKLeaderboard alloc] initWithPlayerIDs:[NSArray arrayWithObject:localPlayer.playerID]];
  query.category = category;
  [query loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
    if (!error && [scores count] > 0)
      block(((GKScore *)[scores objectAtIndex:0]).value);
  }];
  
}

-(void)setupGameKit {
  if ([[self class] canUseGameKit]) {
    localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
      if (localPlayer.isAuthenticated)
      {
        [self fetchScoreForCategory:HIGH_SCORE_CATEGORY callback:^(int value) {
          highScore = 0;//value;
        }];
        [self fetchScoreForCategory:HIGH_LEVEL_CATEGORY callback:^(int value) {
          highLevel = 0;//value;
        }];
        
        [(TitleScreen*)[self sceneNamed:@"menu"] showLeaderboardButton];
        // TODO: Multitasking support? Do I multitask? -- store player id, check if changed, check if logged out, update values
      } else {
        [(TitleScreen*)[self sceneNamed:@"menu"] hideLeaderboardButton];
      }
      
      if (error) {
        NSLog(@"Error authenticating local player with GameKit");
        if (error.code == GKErrorNotSupported) {
          [[self class] neverUseGameKit];
        } else if (error.code == GKErrorGameUnrecognized) {
          NSLog(@"GKErrorGameUnrecognized -- check iTunes Connect and bundle identifier");
        }
      }
    }];
  }
}

-(BOOL)usingGameCenter {
  return (localPlayer != nil) && localPlayer.isAuthenticated;
}

# pragma mark - Common Scene Stuff

-(void)setupBackgroundIn:(TEScene*)scene {
  scene.clearColor = GLKVector4Make(0, 0, 0, 1);
  [scene.characters addObject:[[Background alloc] initInScene:scene]];
  [Starfield addDefaultStarfieldWithWidth:scene.width height:scene.height pixelRatio:POINT_RATIO toScene:scene];
}


@end
