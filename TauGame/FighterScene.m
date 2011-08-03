//
//  FighterScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "FighterScene.h"
#import "Fighter.h"
#import "FighterLife.h"
#import "ShotTimer.h"
#import "Background.h"
#import "StarfieldLayer.h"

@implementation FighterScene

@synthesize fighter, bullets, powerups;

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
      [self setLeft:0 right:12 bottom:0 top:8];
    else
      [self setLeft:0 right:12 bottom:0 top:9];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    [characters insertObject:[[Background alloc] initInScene:self] atIndex:0];
    
    StarfieldLayer *layer = [[StarfieldLayer alloc] init];
    layer.position = GLKVector2Make(0,0);
    layer.width = self.width;
    layer.height = self.height;
    [characters insertObject:layer atIndex:1];
    
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
    for (int i = 0; i < fighter.numShots; i++) {
      [self addShotTimerAtIndex:i];
    }
    
    // Set up notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fighterDied:) name:FighterDiedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extraLife:) name:FighterExtraLifeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extraShot:) name:FighterExtraShotNotification object:nil];
    
    // Set up shooting
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
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

-(void)addShotTimerAtIndex:(int)i {
  ShotTimer *timer = [fighter.shotTimers objectAtIndex:i];
  timer.position = GLKVector2Make(self.topRightVisible.x - 0.6, self.topRightVisible.y - 0.9 - i*0.2);    
  [characters addObject:timer];
}

-(void)extraLife:(NSNotification *)notification {
  [self addLifeDisplayAtIndex:[lives count]];
}

-(void)extraShot:(NSNotification *)notification {
  [self addShotTimerAtIndex:[fighter.shotTimers count]-1];
}

-(void)fighterDied:(NSNotification *)notification {
  // Shot Timers
  for (int i = 1; i < fighter.numShots; i++)
    [characters removeObject:[fighter.shotTimers objectAtIndex:i]];
     
  // Lives
  FighterLife *life = [lives lastObject];
  [lives removeLastObject];
  
  if (life == nil) {
    // TODO: game over screen, etc
    [self exit];
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

-(void)exit {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterDiedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterExtraLifeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterExtraShotNotification object:nil];
  [[TESceneController sharedController] displayScene:@"menu"];
}

@end
