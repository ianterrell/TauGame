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
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
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
          highScore = value;
        }];
        [self fetchScoreForCategory:HIGH_LEVEL_CATEGORY callback:^(int value) {
          highLevel = value;
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

# pragma mark - StoreKit

+(void)markAsUpgraded:(BOOL)upgraded {
  [[NSUserDefaults standardUserDefaults] setBool:upgraded forKey:UPGRADED_PREFERENCES_KEY];
  if (upgraded) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Thanks for upgrading! You'll now start each game with 3 lives and can gain more through powerups." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show]; 
  }
}

+(BOOL)upgraded {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:UPGRADED_PREFERENCES_KEY] == nil)
    [self markAsUpgraded:NO];
  
  return [defaults boolForKey:UPGRADED_PREFERENCES_KEY];
}

-(void)upgrade {
  SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:UPGRADE_PRODUCT_ID]];
  request.delegate = self;
  [request start];
}

-(void)restoreUpgrade {
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  if ([response.products count] == 1) {
    SKPayment *payment = [SKPayment paymentWithProduct:[response.products objectAtIndex:0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
  }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState)
    {
      case SKPaymentTransactionStatePurchased:
        [[self class] markAsUpgraded:YES];
        break;
      case SKPaymentTransactionStateFailed:
        if (transaction.error.code != SKErrorPaymentCancelled)
        {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ruh Roh!" message:@"There was an error upgrading! Please try again. You will NOT be charged twice." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [alert show]; 
        }
        break;
      case SKPaymentTransactionStateRestored:
        [[self class] markAsUpgraded:YES];
      default:
        break;
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
  }
}

# pragma mark - Common Scene Stuff

-(void)setupBackgroundIn:(TEScene*)scene {
  scene.clearColor = GLKVector4Make(0, 0, 0, 1);
  [scene.characters addObject:[[Background alloc] initInScene:scene]];
  [Starfield addDefaultStarfieldWithWidth:scene.width height:scene.height pixelRatio:POINT_RATIO toScene:scene];
}


@end
