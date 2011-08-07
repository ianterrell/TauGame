//
//  Arms.m
//  TauGame
//
//  Created by Ian Terrell on 8/5/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "Arms.h"
#import "GlowingBullet.h"
#import "Game.h"
#import "Fighter.h"

@implementation Arms

-(void)seekInScene:(Game*)game {
  seekingLocation = GLKVector2Make(game.fighter.position.x,[TERandom randomFractionFrom:3 to:7]);
  seekingDelay = 3;
  self.velocity = GLKVector2DivideScalar(GLKVector2Subtract(seekingLocation, self.position),seekingDelay);
}

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"arms"];
    
    numShots = 2;
    shotDelay = 5;
    shotInterval = 0.2;
    shooting = 0;
    self.velocity = GLKVector2Make(1, 0);
    
    
    // Colorize!
    for (TENode *node in [self childrenNamed:[NSArray arrayWithObjects:@"armsdude", @"left arm", @"right arm",nil]]) {
      node.shape.renderStyle = kTERenderStyleVertexColors;
      for (int i = 0; i < node.shape.numVertices; i++) {
        node.shape.colorVertices[i] = self.shape.color;
        if (i == 1 || i == 2)
          node.shape.colorVertices[i] = GLKVector4Make(self.shape.color.r*0.6,self.shape.color.g*0.6,self.shape.color.b*0.6,1);
      }
    }
      
  }
  
  return self;
}

-(void)blink {
  [super blink];
  TENode *eyes = [self childNamed:@"eyes"];
  TEScaleAnimation *animation = [[TEScaleAnimation alloc] init];
  animation.scaleY = 0.25;
  animation.reverse = YES;
  animation.duration = 0.1;
  [eyes startAnimation:animation];
}

-(void)emitBulletsInScene:(Game *)scene {
  [[TESoundManager sharedManager] play:@"shoot"];
  
  for (int i = 0; i < 2; i++) {
    TECharacter *bullet = [[GlowingBullet alloc] initWithColor:self.shape.color];
    float x = self.position.x - 0.615 + i*1.23;
    float y = self.position.y - 0.5;
    bullet.position = GLKVector2Make(x, y);  
    bullet.velocity = GLKVector2Make(0, -5);
    [scene addCharacterAfterUpdate:bullet];
    [scene.enemyBullets addObject:bullet];
  }
  
  shotDelay = 5;
  shooting--;
}

-(void)shootInScene:(Game *)scene {
  // Can't shoot if dead!
  if ([self dead])
    return;
  
  shooting = numShots;
  
  TENode *arms = [self childNamed:@"arms"];
  TETranslateAnimation *animation = [[TETranslateAnimation alloc] init];
  animation.translation = GLKVector2Make(0, 0.15);
  animation.reverse = YES;
  animation.duration = 0.1;
  animation.repeat = numShots-1;
  animation.onComplete = ^(){
    [self emitBulletsInScene:scene];
  };
  [arms startAnimation:animation];
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];
  
  if (shotDelay > 0)
    shotDelay -= dt;
  if (shotDelay <= 0 && shooting == 0)
    [self shootInScene:(Game*)scene];

  if (seekingDelay > 0)
    seekingDelay -= dt;
  if (seekingDelay <= 0)
    [self seekInScene:(Game*)scene];
  
  [self updateBlink:dt];
  
  [self wraparoundInScene:scene];
}

-(void)flashWhite {
  for (TENode *node in [self childrenNamed:[NSArray arrayWithObjects:@"armsdude", @"left arm", @"right arm",nil]])
    [node startAnimation:[self flashWhiteAnimation]];
}

@end
