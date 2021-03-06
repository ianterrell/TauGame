//
//  FighterScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "Game.h"
#import "Fighter.h"
#import "FighterLife.h"
#import "ShotTimer.h"
#import "Bullet.h"
#import "BulletSplash.h"
#import "ExtraBullet.h"
#import "ExtraLife.h"
#import "ExtraShot.h"
#import "ExtraHealth.h"
#import "ScoreBonus.h"
#import "GameLevel.h"
#import "GameButton.h"

#import "Enemy.h"

#import "LevelBag.h"
#import "WeaponPowerupBag.h"

static LevelBag *levelBag;
static WeaponPowerupBag *weaponPowerupBag;

@implementation Game

@synthesize fighter, bullets, powerups, enemies, enemyBullets;
@synthesize currentLevelNumber, gameIsOver, levelLoading;

+(void)initialize {
  levelBag = [[LevelBag alloc] init];
  weaponPowerupBag = [[WeaponPowerupBag alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Set up coordinates
    CGSize parentSize = frame.size;
    float extraScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
    [self setLeft:0 right:parentSize.width/(extraScale*POINT_RATIO) bottom:0 top:parentSize.height/(extraScale*POINT_RATIO)];
    
    // Set up background
    [[GameController sharedController] setupBackgroundIn:self];
    
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
    if ([GameController upgraded]) {
      lives = [[NSMutableArray alloc] initWithCapacity:fighter.lives];
      for (int i = 0; i < fighter.lives-1; i++)
        [self addLifeDisplayAtIndex:i];
    } else {
      GameButton *upgrade  = [[GameButton alloc] initWithText:@"UPGRADE" font:[UIFont fontWithName:@"Helvetica-Bold" size:32]];
      GameButton *upgrade2 = [[GameButton alloc] initWithText:@"FOR LIVES" font:[UIFont fontWithName:@"Helvetica-Bold" size:32]];
      upgrade.position  = GLKVector2Make(self.right-0.75*((TESprite*)upgrade2.shape).width/2, self.top - 1.25*0.5*((TESprite*)upgrade.shape).height/2);
      upgrade2.position = GLKVector2Make(self.right-0.75*((TESprite*)upgrade2.shape).width/2, self.top - 1.25*0.5*((TESprite*)upgrade.shape).height);
      [characters addObject:upgrade];
      [characters addObject:upgrade2];
    }
    
    // Set up shot timers display
    for (int i = 0; i < fighter.numShots; i++) {
      [self addShotTimerAtIndex:i];
    }
    
    // Set up shooting, etc
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnce:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // Set up score
    scoreboard = [[TENode alloc] init];
    TENumberDisplay *scoreboardDisplay = [[TENumberDisplay alloc] initWithNumDigits:8];
    scoreboardDisplay.node = scoreboard;
    scoreboardDisplay.width = 3;
    scoreboard.drawable = scoreboardDisplay;
    scoreboard.position = GLKVector2Make(self.bottomLeftVisible.x + scoreboardDisplay.width/2.0, self.topRightVisible.y - scoreboardDisplay.height/2.0);
    [characters addObject:scoreboard];
    
    // Set up multiplier
    multiplierDisplay = [[TENumberDisplay alloc] initWithNumDigits:8];
    multiplierDisplay.hiddenDigits = 5;
    multiplierDisplay.decimalPointDigit = 1;
    [self resetMultiplier];
    
    TENode *multiplier = [TENode nodeWithDrawable:multiplierDisplay];
    multiplier.position = GLKVector2Make(self.width/2.0, self.topRightVisible.y - multiplierDisplay.height/2.0);
    [characters addObject:multiplier];
    
    UIFont *xFont = [UIFont fontWithName:@"Courier-Bold" size:16];
    UIColor *xColor = [UIColor colorWithWhite:1 alpha:1];
    multiplierX = [TENode nodeWithDrawable:[[TESprite alloc] initWithImage:[TEImage imageFromText:@"x" withFont:xFont color:xColor] pointRatio:POINT_RATIO]];
    multiplierX.position = GLKVector2Make(self.width/2.0+multiplierDisplay.width/2+0.3, multiplier.position.y);
    [characters addObject:multiplierX];
    
    
    // Set up level
    gameIsOver = readyToExit = NO;
    currentLevelNumber = 0;
    [self loadNextLevel];
  }
  
  return self;
}

# pragma mark - Levels

-(void)loadNextLevel {
  if ([fighter dead])
    return;
  
  if (currentLevelNumber > 0 && currentLevelNumber % WEAPON_POWERUP_PER_N_LEVELS == 0)
    [self dropWeaponPowerupAt:GLKVector2Make(self.center.x, self.top)];
  
  currentLevel = nil;
  levelLoading = YES;
  currentLevelNumber++;
  
#ifdef DEBUG_SKIP_LEVELS
  currentLevelNumber += DEBUG_SKIP_LEVELS;
#endif
  
  Class nextLevelClass = [levelBag drawItem];
  
  // Set up level name display
  TENode *levelName = [nextLevelClass nameSpriteWithPointRatio:POINT_RATIO];
  levelName.scale = 0.2;
  levelName.position = GLKVector2Make(self.width/2, self.height/2);
  TEScaleAnimation *scaleAnimation = [[TEScaleAnimation alloc] init];
  scaleAnimation.scale = 5;
  scaleAnimation.duration = 1;
  scaleAnimation.onRemoval = ^(){
    levelName.remove = YES;
    
    if ([fighter dead])
      return;
    
    currentLevel = [[nextLevelClass alloc] initWithGame:self];
    [self resetMultiplierDecayTimer];
  };
  [levelName startAnimation:scaleAnimation];
  
  // Set up level number display
  UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
  TESprite *sprite = [[TESprite alloc] initWithImage:[TEImage imageFromText:[NSString stringWithFormat:@"Level %d", currentLevelNumber] withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
  TENode *levelDisplay = [TENode nodeWithDrawable:sprite];
  levelDisplay.scale = 0.2;
  levelDisplay.position = GLKVector2Make(self.width/2, self.height/2);
  TEScaleAnimation *scaleAnimation2 = [[TEScaleAnimation alloc] init];
  scaleAnimation2.scale = 5;
  scaleAnimation2.duration = 1;
  scaleAnimation2.onRemoval = ^(){
    levelDisplay.remove = YES;
    [self addCharacterAfterUpdate:levelName];
  };
  [levelDisplay startAnimation:scaleAnimation2];  
  
  // Kick it off
  [characters addObject:levelDisplay];
}

# pragma mark - Updating

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  if (!levelLoading) { // grace period while loading
    // Detect collisions with bullets :)
    BOOL recurseRight = currentLevel == nil ? NO : currentLevel.recurseEnemiesForCollisions;
    [TECollisionDetector collisionsBetween:bullets andNodes:enemies recurseLeft:NO recurseRight:recurseRight maxPerNode:1 withBlock:^(TENode *bullet, TENode *enemy) {
      bullet.remove = YES;
      [self addBulletSplashAt:bullet.position];
      
      [(Enemy *)enemy registerHit];
      [self incrementMultiplier:MULTIPLIER_PER_HIT];
      [self incrementScore:((Enemy *)enemy).pointsPerHit];
    }];
    
    // Detect collisions with ship :(
    [TECollisionDetector collisionsBetweenNode:fighter andNodes:enemyBullets maxPerNode:1 withBlock:^(TENode *ship, TENode *enemyBullet) {
      [(Fighter *)fighter registerHitInScene:self];
      
      if ([enemyBullet isKindOfClass:[Bullet class]])
        [(Bullet *)enemyBullet explode];
    }];
  }
  
  // Detect powerup collisions -- even if invincible from death or injury
  BOOL previousCollide = fighter.collide;
  fighter.collide = YES;
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:powerups withBlock:^(TENode *ship, TENode *powerup) {
    [(Powerup*)powerup die];
    [fighter getPowerup:(Powerup*)powerup inScene:self];
  }];
  fighter.collide = previousCollide;
  
  // Decay multiplier
  if (!levelLoading) {
    if (multiplierTimer > 0)
      multiplierTimer -= [controller timeSinceLastUpdate];
    else
      [self decayMultiplier];
  }
  
  if (currentLevel != nil) {
    [currentLevel update:[controller timeSinceLastUpdate]];
    if ([currentLevel done])
      [self loadNextLevel];
  }
}

# pragma mark - Touch Controls

-(void)tappedOnce:(UIGestureRecognizer *)gestureRecognizer {
  CGPoint locationInView = [gestureRecognizer locationInView:self.view];
  CGSize frameSize = self.view.frame.size;
  float xfraction = 0.33;
  float yfraction = 0.2;
  
  if (readyToExit)
    [[GameController sharedController] displayScene:@"menu" duration:3 options:(UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionCrossDissolve) completion:^(BOOL finished) {
      [[GameController sharedController] removeScene:@"game"];
    }];
  else if (locationInView.y < yfraction*frameSize.height && locationInView.x > (1-xfraction)*frameSize.width)
    [self pauseGame];
  else
    [fighter shootInScene:self];
}

# pragma mark - Multiplier

-(void)resetMultiplier {
  [self setMultiplier:10];
  [self resetMultiplierDecayTimer];
}

-(void)resetMultiplierDecayTimer {
  multiplierTimer = MULTIPLIER_DECAY_INTERVAL;
}

-(void)decayMultiplier {
  [self incrementMultiplier:-1*MULTIPLIER_DECAY_AMOUNT];
}

-(void)incrementMultiplier:(int)increment {
  [self resetMultiplierDecayTimer];
  [self setMultiplier:multiplierDisplay.number+increment];
}

-(void)setMultiplier:(int)multiplierNum {
  multiplierNum = MAX(MIN_MULTIPLIER,MIN(MAX_MULTIPLIER,multiplierNum));
  int digits = 0;
  int tmp = multiplierNum;
  while (tmp > 0) {
    digits++;
    tmp /= 10;
  }
  multiplierDisplay.hiddenDigits = 8-(digits+1);
  multiplierDisplay.width = 0.33*(digits+1);
  multiplierDisplay.number = multiplierNum;
  
  multiplierX.position = GLKVector2Make(self.width/2.0+multiplierDisplay.width/2+(digits==2?0.3:0.1),multiplierX.position.y);
}

-(float)multiplierValue {
  return ((float)multiplierDisplay.number)/10;
}

# pragma mark - Score

-(int)score {
  return ((TENumberDisplay *)scoreboard.drawable).number;
}

-(void)incrementScore:(int)score {
  ((TENumberDisplay *)scoreboard.drawable).number += score * currentLevelNumber * [self multiplierValue];
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
  // Lives
  FighterLife *life = [lives lastObject];
  [lives removeLastObject];
  
  // Multiplier
  [self resetMultiplier];
  
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
  [self incrementMultiplier:MULTIPLIER_PER_KILL];
  [self incrementScoreWithPulse:enemy.pointsForDestruction];
  [self potentiallyDropPowerupAt:enemy.position];
}

# pragma mark - Powerups

-(void)dropWeaponPowerupAt:(GLKVector2)position {
  [[weaponPowerupBag drawItem] addPowerupToScene:self at:position];
}

-(void)potentiallyDropPowerupAt:(GLKVector2)position {
  float randomFraction = [TERandom randomFraction];
  float threshold = 1.0;
  Class clazz = nil;
  if (randomFraction >= (threshold -= POWERUP_SHOT_CHANCE))
    clazz = [ExtraShot class];
  else if (randomFraction >= (threshold -= POWERUP_BULLET_CHANCE))
    clazz = [ExtraBullet class];
  else if ([GameController upgraded] && randomFraction >= (threshold -= POWERUP_LIFE_CHANCE))
    clazz = [ExtraLife class];
  else if (randomFraction >= (threshold -= POWERUP_HEALTH_CHANCE))
    clazz = [ExtraHealth class];
  else if (randomFraction >= (threshold -= POWERUP_SCORE_CHANCE))
    clazz = [ScoreBonus class];
  
  if (clazz != nil)
    [clazz addPowerupToScene:self at:position];
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

# pragma mark - Scene Transitions

-(void)pauseGame {
  [[GameController sharedController] displayScene:@"pause" duration:0.4 options:UIViewAnimationOptionTransitionFlipFromTop completion:NULL];
}

-(void)exit {
  if ([[GameController sharedController] usingGameCenter]) {
    GKScore *highScoreReporter = [[GKScore alloc] initWithCategory:HIGH_SCORE_CATEGORY];
    highScoreReporter.value = [self score];
    
    [highScoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
      if (error != nil)
      {
        NSLog(@"Could not report high score!");
        // TODO: Store score report and resend later
      }
    }];
    
    GKScore *highLevelReporter = [[GKScore alloc] initWithCategory:HIGH_LEVEL_CATEGORY];
    highLevelReporter.value = currentLevelNumber;
    
    [highLevelReporter reportScoreWithCompletionHandler:^(NSError *error) {
      if (error != nil)
      {
        NSLog(@"Could not report high level!");
        // TODO: Store score report and resend later
      }
    }];
  }
  
  gameIsOver = YES;
  
  float exitAnimationDuration = 3;
  
  // Set up darkening mask
  TERectangle *rectangle = [[TERectangle alloc] init];
  rectangle.width = self.width;
  rectangle.height = self.height;
  rectangle.color = GLKVector4Make(0,0,0,0);
  TENode *mask = [TENode nodeWithDrawable:rectangle];
  mask.position = self.center;
  [characters addObject:mask];
  
  TEColorAnimation *maskAnimation = [[TEColorAnimation alloc] initWithNode:mask];
  maskAnimation.color = GLKVector4Make(0,0,0,0.5);
  maskAnimation.duration = exitAnimationDuration;
  maskAnimation.permanent = YES;
  [mask startAnimation:maskAnimation];
  
  // Set up game over words
  UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:64];
  TESprite *gameOver = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"GAME OVER" withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
  TENode *gameOverNode = [TENode nodeWithDrawable:gameOver];
  gameOverNode.scaleX = 0.9;
  gameOverNode.scaleY = 0.5;
  gameOverNode.position = GLKVector2Make(self.width/2,self.height+gameOver.height/2);
  [characters addObject:gameOverNode];
  
  TETranslateAnimation *goAnimation = [[TETranslateAnimation alloc] initWithNode:gameOverNode];
  goAnimation.translation = GLKVector2Make(0,self.height/2-gameOverNode.position.y);
  goAnimation.duration = exitAnimationDuration;
  goAnimation.permanent = YES;
  goAnimation.onComplete = ^() {
    if ([self score] > [GameController sharedController].highScore) {
      [GameController sharedController].highScore = [self score];
      
      UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
      TESprite *newHighScore = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"New High Score!" withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
      TENode *newHighScoreNode = [TENode nodeWithDrawable:newHighScore];
      newHighScoreNode.scaleX = 0.9;
      newHighScoreNode.scaleY = 0.5;
      newHighScoreNode.position = GLKVector2Make(self.width/2,self.center.y-0.5*gameOver.height/2-1.5*0.5*newHighScore.height/2);
      [characters addObject:newHighScoreNode];
      
      TEScaleAnimation *animation = [[TEScaleAnimation alloc] init];
      animation.scale = 1.2;
      animation.duration = 0.5;
      animation.reverse = YES;
      animation.repeat = kTEAnimationRepeatForever;
      [newHighScoreNode.currentAnimations addObject:animation];
    }
    
    if (currentLevelNumber > [GameController sharedController].highLevel) {
      [GameController sharedController].highLevel = currentLevelNumber;
      
      UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
      TESprite *newHighLevel = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"New High Level!" withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
      TENode *newHighLevelNode = [TENode nodeWithDrawable:newHighLevel];
      newHighLevelNode.scaleX = 0.9;
      newHighLevelNode.scaleY = 0.5;
      newHighLevelNode.position = GLKVector2Make(self.width/2,self.center.y+0.5*gameOver.height/2+1.5*0.5*newHighLevel.height/2);
      [characters addObject:newHighLevelNode];
      
      TEScaleAnimation *animation = [[TEScaleAnimation alloc] init];
      animation.scale = 1.2;
      animation.duration = 0.5;
      animation.reverse = YES;
      animation.repeat = kTEAnimationRepeatForever;
      [newHighLevelNode.currentAnimations addObject:animation];
    }

    
    readyToExit = YES;
  };
  [gameOverNode startAnimation:goAnimation];
}

@end
