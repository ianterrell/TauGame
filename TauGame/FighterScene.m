//
//  FighterScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "FighterScene.h"

@implementation FighterScene

@synthesize fighter, bullets;

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
    
    // Set up fighter
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make(6, 0.1);
    fighter.maxVelocity = 20;
    fighter.maxAcceleration = 40;
    [characters addObject:fighter];
    
    // Set up shooting
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self addGestureRecognizer:tapRecognizer];
    
    // Set up sounds
    sounds = [[TESoundManager alloc] init];
    [sounds load:@"shoot"];
    [sounds load:@"hurt"];
  }
  
  return self;
}

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation {
  return orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight;
}

-(void)orientationChangedTo:(UIDeviceOrientation)orientation {
  [super orientationChangedTo:orientation];
  fighter.position = GLKVector2Make(fighter.position.x, self.bottomLeftVisible.y + 0.1);
}

-(void)tappedOnce:(UIGestureRecognizer *)gestureRecognizer {
  [self shoot];
}

-(void) shoot {
  [sounds play:@"shoot"];
  
  TECharacter *bullet = [[Bullet alloc] init];
  bullet.position = GLKVector2Make(fighter.position.x, fighter.position.y + 1.1);
  bullet.velocity = GLKVector2Make(0, 5);
  [characters addObject:bullet];
  [bullets addObject:bullet];
}


@end
