//
//  FighterScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauGameAppDelegate.h"
#import "FighterScene.h"
#import "Fighter.h"
#import "FighterLife.h"
#import "ShotTimer.h"
#import "Background.h"

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
    [characters insertObject:[[Background alloc] initInScene:self] atIndex:0];
    
    // Set up our special character arrays for collision detection
    bullets = [[NSMutableArray alloc] initWithCapacity:20];
    powerups = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Set up fighter
    fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2, self.bottomLeftVisible.y + 0.1);
    [characters addObject:fighter];
    
    // Set up lives display
    lives = [[NSMutableArray alloc] initWithCapacity:fighter.lives];
    for (int i = 0; i < fighter.lives-1; i++)
      [self addLifeDisplayAtIndex:i];
    
    // Set up shot timers display
//    shotTimers = [[NSMutableArray alloc] initWithCapacity:fighter.numShots];
//    for (int i = 0; i < fighter.numShots; i++) {
//      ShotTimer *timer = [[ShotTimer alloc] init];
//      timer.position = GLKVector2Make(self.topRightVisible.x - 0.6, self.topRightVisible.y - 0.9);
//      [shotTimers addObject:timer];
//      [characters addObject:timer];
//    }
    for (ShotTimer *timer in fighter.shotTimers) {
      timer.position = GLKVector2Make(self.topRightVisible.x - 0.6, self.topRightVisible.y - 0.9);
      [characters addObject:timer];
    }
    
    // Set up notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fighterDied:) name:FighterDiedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extraLife:) name:FighterExtraLifeNotification object:nil];
    
    // Set up shooting
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self addGestureRecognizer:tapRecognizer];
    
    // Set up score
    scoreboard = [[TECharacter alloc] init];
    TENumberDisplay *scoreboardDisplay = [[TENumberDisplay alloc] initWithNumDigits:8];
    scoreboardDisplay.node = scoreboard;
    scoreboardDisplay.width = 3;
    scoreboard.drawable = scoreboardDisplay;
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

-(void)incrementScore:(int)score {
  ((TENumberDisplay *)scoreboard.drawable).number += score;
}

-(void)incrementScoreWithPulse:(int)score {
  [self incrementScore:score];
  
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 1.2;
  scaleAnimation.duration = 0.2;
  scaleAnimation.reverse = YES;
  [scoreboard.currentAnimations addObject:scaleAnimation];
  
  TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
  translateAnimation.translation = GLKVector2Make((((TENumberDisplay *)scoreboard.drawable).width*1.2-((TENumberDisplay *)scoreboard.drawable).width)/2, -1*(((TENumberDisplay *)scoreboard.drawable).height*1.2-((TENumberDisplay *)scoreboard.drawable).height)/2);
  translateAnimation.duration = 0.2;
  translateAnimation.reverse = YES;
  [scoreboard.currentAnimations addObject:translateAnimation];
}

-(void)addLifeDisplayAtIndex:(int)i {
  FighterLife *life = [[FighterLife alloc] init];
  life.scale = 0.5;
  life.shape.color = GLKVector4Make(1,1,1,0);
  life.position = GLKVector2Make(self.topRightVisible.x - life.shape.radius/2 - i*life.shape.radius*0.85, self.topRightVisible.y - life.shape.radius/2 - 0.05);

  TEColorAnimation *colorAnimation = [[TEColorAnimation alloc] init];
  colorAnimation.color = GLKVector4Make(1,1,1,1);
  colorAnimation.duration = 1;
  colorAnimation.onRemoval = ^(){
    life.shape.color = GLKVector4Make(1,1,1,1);
  };
  [life.currentAnimations addObject:colorAnimation];
  [life markModelViewMatrixDirty];
  
  [lives addObject:life];
  [characters addObject:life];
}

-(void)extraLife:(NSNotification *)notification {
  [self addLifeDisplayAtIndex:[lives count]];
}

-(void)fighterDied:(NSNotification *)notification {
  FighterLife *life = [lives lastObject];
  [lives removeLastObject];
  
  if (life == nil) {
    // TODO: game over screen, etc
    [((TauGameAppDelegate*)[UIApplication sharedApplication].delegate) showMainMenuController];
  } else {
    TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
    scaleAnimation.scale = 0;
    scaleAnimation.duration = 0.1;
    scaleAnimation.onRemoval = ^(){
      life.remove = YES;
    };
    
    TEColorAnimation *transparent = [[TEColorAnimation alloc] initWithNode:life];
    transparent.color = GLKVector4Make(1, 1, 1, 0.5);
    transparent.duration = 0.25;
    transparent.reverse = YES;
    transparent.repeat = 2;
    transparent.next = scaleAnimation;
    
    [life.currentAnimations addObject:transparent];
  }
}

-(void)nodeRemoved:(TENode *)node {
  if ([node isKindOfClass:[Bullet class]])
    [bullets removeObject:node];
  else if ([node isKindOfClass:[Powerup class]])
    [powerups removeObject:node];
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterDiedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterExtraLifeNotification object:nil];
}

@end
