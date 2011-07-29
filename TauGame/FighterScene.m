//
//  FighterScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "FighterScene.h"
#import "Fighter.h"

@implementation FighterScene

@synthesize fighter, bullets, powerups;

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    [self setLeft:0 right:8 bottom:0 top:12];
    [self orientationChangedTo:UIDeviceOrientationLandscapeLeft];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    
    // Set up our special character arrays for collision detection
    bullets = [[NSMutableArray alloc] initWithCapacity:20];
    powerups = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Set up fighter
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2, self.bottomLeftVisible.y + 0.1);
    [characters addObject:fighter];
    
    // Set up shooting
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self addGestureRecognizer:tapRecognizer];
    
    // Set up score
    scoreboard = [[TECharacter alloc] init];
    TENumberDisplay *scoreboardDisplay = [[TENumberDisplay alloc] initWithNumDigits:8];
    scoreboardDisplay.node = scoreboard;
    scoreboardDisplay.width = 3;
    scoreboard.drawable = scoreboardDisplay;
    NSLog(@"width %f height %f", scoreboardDisplay.width, scoreboardDisplay.height);
    scoreboard.position = GLKVector2Make(self.bottomLeftVisible.x + scoreboardDisplay.width/2.0, self.topRightVisible.y - scoreboardDisplay.height/2.0);
    [characters addObject:scoreboard];
  }
  
  return self;
}

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation {
  return UIDeviceOrientationIsLandscape(orientation);
}

-(void)tappedOnce:(UIGestureRecognizer *)gestureRecognizer {
  [fighter shootInScene:self];
}

@end
