//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"
#import <AudioToolbox/AudioServices.h>

SystemSoundID shootSound;
SystemSoundID hurtSound;

@implementation AsteroidField

@synthesize bullets, ships;

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
    ships = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Set up fighter
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make(6, 0.1);
    fighter.maxVelocity = 20;
    fighter.maxAcceleration = 40;
    [characters addObject:fighter];
    [ships addObject:fighter];
    
    // Set up a baddie
    [self addRandomBaddie];
    [self addRandomBaddie];
    [self addRandomBaddie];
    
    // Set up shooting
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self addGestureRecognizer:tapRecognizer];
    
    // Set up sounds
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shoot" ofType:@"wav"]], &shootSound);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hurt" ofType:@"wav"]], &hurtSound);
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

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  // Detect collisions
  [TECollisionDetector collisionsBetween:bullets andNodes:ships maxPerNode:1 withBlock:^(TENode *bullet, TENode *ship) {
    // We've hit a baddie!
    AudioServicesPlaySystemSound(hurtSound);
    
    // Remove the bullet
    bullet.remove = YES;
    
    // Highlight a hit
    TEColorAnimation *highlight = [[TEColorAnimation alloc] initWithNode:ship];
    highlight.color = GLKVector4Make(1, 1, 1, 1);
    highlight.duration = 0.1;
    highlight.onRemoval = ^(){
      ship.remove = YES;
    };
    
    [ship.currentAnimations addObject:highlight];
  }];
}

-(void)tappedOnce:(UIGestureRecognizer *)gestureRecognizer {
  [self shoot];
}

-(void) shoot {
  AudioServicesPlaySystemSound(shootSound);
  
  TECharacter *bullet = [[Bullet alloc] init];
  bullet.position = GLKVector2Make(fighter.position.x, fighter.position.y + 1.1);
  bullet.velocity = GLKVector2Make(0, 5);
  [characters addObject:bullet];
  [bullets addObject:bullet];
}

-(void)addRandomBaddie {
  Baddie *baddie = [[Baddie alloc] init];

//  srand(arc4random());
  
  float randX = ((float)rand()/RAND_MAX) * self.visibleWidth + self.bottomLeftVisible.x;
  float randY = ((float)rand()/RAND_MAX) * (self.visibleHeight - 3) + self.bottomLeftVisible.y + 3;
  float randVelocity = -10.0 + (float)rand()/RAND_MAX * 20.0;
  NSLog(@"y is %f", randY);
  baddie.position = GLKVector2Make(randX, randY);
  baddie.velocity = GLKVector2Make(randVelocity,0);
  baddie.shape.color = GLKVector4Make(((float)rand()/RAND_MAX), ((float)rand()/RAND_MAX), ((float)rand()/RAND_MAX), 1.0);
  
  if ((float)rand()/RAND_MAX > 0.8) {
    TEScaleAnimation *grow = [[TEScaleAnimation alloc] init];
    grow.scale = 1.2;
    grow.duration = 1;
    grow.repeat = TEAnimationRepeatForever;
    [baddie.currentAnimations addObject:grow];
  }
  
  if ((float)rand()/RAND_MAX > 0.8) {
    TERotateAnimation *spin = [[TERotateAnimation alloc] init];
    spin.rotation = 1*M_TAU;
    spin.duration = 1;
    spin.repeat = TEAnimationRepeatForever;
    [baddie.currentAnimations addObject:spin];
  }
  
  [self.characters addObject:baddie];
  [ships addObject:baddie];
}

@end

// Scratch code!

//// Set up a label!
//UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
//title.text = @"Alien Invasion";
//title.backgroundColor = [UIColor clearColor];
//title.textColor = [UIColor whiteColor];
//title.transform = CGAffineTransformMakeRotation(-0.25*M_TAU);
//[self addSubview:title];    
//[self bringSubviewToFront:title];
