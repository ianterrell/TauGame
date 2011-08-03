//
//  BaddieField.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "BaddieField.h"
#import "Fighter.h"
#import "SeekNShoot.h"

@implementation BaddieField

@synthesize baddieBullets;

@synthesize baddies;

- (id)init
{
  self = [super init];
  if (self) {
    // Set up baddie array for collision detection
    baddies = [[NSMutableArray alloc] initWithCapacity:5];
    baddieBullets = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Set up a baddie
    [self addRandomBaddie];
    [self addRandomBaddie];
    [self addRandomBaddie];
  }
  
  return self;
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller {  
  [super glkViewControllerUpdate:controller];
  
  // Shoot the baddies! :)
  [TECollisionDetector collisionsBetween:bullets andNodes:baddies maxPerNode:1 withBlock:^(TENode *bullet, TENode *ship) {
    bullet.remove = YES;
    [self addBulletSplashAt:bullet.position];
    [(Baddie *)ship registerHit];
    [self incrementScore:1];
  }];
  
  // Don't get shot! :(
  [TECollisionDetector collisionsBetweenNode:fighter andNodes:baddieBullets maxPerNode:1 withBlock:^(TENode *fighterNode, TENode *bullet) {
    bullet.remove = YES;
    [fighter registerHit];
  }];
}

-(void)addRandomBaddie {
  Baddie *baddie = [[SeekNShoot alloc] init];
  
  float randX = [TERandom randomFraction] * self.visibleWidth + self.bottomLeftVisible.x;
  float randY = [TERandom randomFraction] * (self.visibleHeight - 3) + self.bottomLeftVisible.y + 3;
  
  baddie.position = GLKVector2Make(randX, randY);
  baddie.shape.color = GLKVector4Make([TERandom randomFractionFrom:0.5 to:1], [TERandom randomFractionFrom:0.5 to:1], [TERandom randomFractionFrom:0.5 to:1], 1.0);
  
  [self.characters addObject:baddie];
  [baddies addObject:baddie];
}

-(void)nodeRemoved:(TENode *)node {
  [super nodeRemoved:node];
  if ([node isKindOfClass:[Baddie class]]) {
    [baddies removeObject:node];
    [self addRandomBaddie];
  } else if ([node isKindOfClass:[Bullet class]])
    [baddieBullets removeObject:node];
}


-(void)baddieDestroyed:(NSNotification *)notification {
  Baddie *baddie = notification.object;
  [self incrementScoreWithPulse:10];
  [self dropPowerupWithPercentChance:0.1 at:baddie.position];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baddieDestroyed:) name:BaddieDestroyedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:BaddieDestroyedNotification object:nil];
}

@end
