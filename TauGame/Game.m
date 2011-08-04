//
//  FighterScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Game.h"
#import "Fighter.h"
#import "FighterLife.h"
#import "ShotTimer.h"
#import "Background.h"
#import "StarfieldLayer.h"
#import "Bullet.h"
#import "BulletSplash.h"
#import "ExtraBullet.h"
#import "ExtraLife.h"
#import "ExtraShot.h"

#import "AsteroidField.h"
#import "ClassicHorde.h"
#import "Enemy.h"

#define POWERUP_CHANCE 0.1
#define NUM_POWERUPS 3

#define POINT_RATIO 40

#define NUM_LEVELS 2

static Class powerupClasses[NUM_POWERUPS];
static Class levelClasses[NUM_LEVELS];

@implementation Game

@synthesize fighter, bullets, powerups, enemies, enemyBullets;
@synthesize currentLevelNumber;

+(void)initialize {
  int i = 0;
  powerupClasses[i++] = [ExtraBullet class];
  powerupClasses[i++] = [ExtraLife class];
  powerupClasses[i++] = [ExtraShot class];
  
  int j = 0;
  levelClasses[j++] = [AsteroidField class];
  levelClasses[j++] = [ClassicHorde class];
}

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    CGSize parentSize = [TESceneController sharedController].container.frame.size;
    [self setLeft:0 right:parentSize.width/POINT_RATIO bottom:0 top:parentSize.height/POINT_RATIO];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    [characters insertObject:[[Background alloc] initInScene:self] atIndex:0];
    
    StarfieldLayer *layer = [[StarfieldLayer alloc] initWithWidth:self.width height:self.height pixelRatio:POINT_RATIO numStars:500];
    layer.position = GLKVector2Make(0,0);
    [characters insertObject:layer atIndex:1];
    
    // Set up our special character arrays for collision detection
    bullets      = [[NSMutableArray alloc] initWithCapacity:20];
    powerups     = [[NSMutableArray alloc] initWithCapacity:3];
    enemies      = [[NSMutableArray alloc] initWithCapacity:20];
    enemyBullets = [[NSMutableArray alloc] initWithCapacity:20];
    
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
    
    // Set up level
    currentLevelNumber = 0;
    [self loadNextLevel];
  }
  
  return self;
}

# pragma mark - Levels

-(void)loadNextLevel {
  currentLevel = nil;
  currentLevelNumber++;
  
  UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
  TESprite *sprite = [[TESprite alloc] initWithImage:[TEImage imageFromText:[NSString stringWithFormat:@"Level %d", currentLevelNumber] withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
  TENode *levelDisplay = [TENode nodeWithDrawable:sprite];

  levelDisplay.scale = 0.2;
  levelDisplay.position = GLKVector2Make(self.width/2, self.height/2);
  
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 5;
  scaleAnimation.duration = 1;
  scaleAnimation.onRemoval = ^(){
    levelDisplay.remove = YES;
    currentLevel = [[levelClasses[[TERandom randomTo:NUM_LEVELS]] alloc] initWithGame:self];
  };
  [levelDisplay startAnimation:scaleAnimation];
  
  [characters addObject:levelDisplay];
}

# pragma mark - Updating

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  // Detect collisions with bullets :)
  [TECollisionDetector collisionsBetween:bullets andNodes:enemies maxPerNode:1 withBlock:^(TENode *bullet, TENode *enemy) {
    bullet.remove = YES;
    [self addBulletSplashAt:bullet.position];
    
    [(Enemy *)enemy registerHit];
    [self incrementScore:((Enemy *)enemy).pointsPerHit];
  }];
  
  // Detect collisions with ship :(
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:enemyBullets maxPerNode:1 withBlock:^(TENode *ship, TENode *enemyBullet) {
    [(Fighter *)fighter registerHit];
    [(Enemy *)enemyBullet explode];
  }];
  
  // Detect powerup collisions
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:powerups withBlock:^(TENode *ship, TENode *powerup) {
    [(Powerup*)powerup die];
    [fighter getPowerup:(Powerup*)powerup];
  }];
  
  if (currentLevel != nil) {
    [currentLevel update];
    if ([currentLevel done])
      [self loadNextLevel];
  }
}

# pragma mark - Touch Controls

-(void)tappedOnce:(UIGestureRecognizer *)gestureRecognizer {
  CGPoint locationInView = [gestureRecognizer locationInView:self.view];
  CGSize frameSize = self.view.frame.size;
  float fraction = 0.33;
  
  // Pause or shoot!
  if (locationInView.y < fraction*frameSize.height && locationInView.x > (1-fraction)*frameSize.width)
    [[TESceneController sharedController] displayScene:@"pause" duration:0.4 options:UIViewAnimationOptionTransitionFlipFromTop completion:NULL];
  else
    [fighter shootInScene:self];
}

# pragma mark - Score

-(void)incrementScore:(int)score {
  ((TENumberDisplay *)scoreboard.drawable).number += score * currentLevelNumber;
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

# pragma mark - HUD

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
  [life startAnimation:colorAnimation];
  
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

# pragma mark - Notifications

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

-(void)enemyDestroyed:(NSNotification *)notification {
  Enemy *enemy = notification.object;
  [self incrementScoreWithPulse:enemy.pointsForDestruction];
  [self dropPowerupWithPercentChance:0.1 at:enemy.position];
}

# pragma mark - Powerups

-(void)dropPowerupWithPercentChance:(float)percent at:(GLKVector2)position {
  if ([TERandom randomFraction] < percent) {
    [powerupClasses[[TERandom randomTo:NUM_POWERUPS]] addPowerupToScene:self at:position];
  }
}

# pragma mark - Effects

-(void)addBulletSplashAt:(GLKVector2)position {
  [self.characters addObject:[[BulletSplash alloc] initWithPosition:position]];
}

-(void)nodeRemoved:(TENode *)node {
  if ([node isKindOfClass:[Bullet class]]) {
    [bullets removeObject:node];
    [enemyBullets removeObject:node];
  }
  else if ([node isKindOfClass:[Powerup class]]) {
    [powerups removeObject:node];
  }
  else if ([node isKindOfClass:[Enemy class]]) {
    [enemies removeObject:node];
    [enemyBullets removeObject:node];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fighterDied:) name:FighterDiedNotification object:fighter];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extraLife:) name:FighterExtraLifeNotification object:fighter];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(extraShot:) name:FighterExtraShotNotification object:fighter];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enemyDestroyed:) name:EnemyDestroyedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterDiedNotification object:fighter];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterExtraLifeNotification object:fighter];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:FighterExtraShotNotification object:fighter];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:EnemyDestroyedNotification object:nil];
}

-(void)exit {
  [[TESceneController sharedController] displayScene:@"menu"];
}

@end
