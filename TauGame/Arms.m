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

@synthesize seekingOffset, numShots;

+(BaddieShootingStyle)shootingStyle {
  return kBaddieRandomShot;
}

- (id)init
{
  self = [super init];
  if (self) {
    [TENodeLoader loadCharacter:self fromJSONFile:@"arms"];
    
    numShots = 2;
    seekingOffset = 0;
    shotInterval = 0.2;
    shooting = 0;
    self.velocity = GLKVector2Make(1, 0);
    
    appendages = [self childrenNamed:[self appendageNames]];
    [self setupLegs];
    
    [self resetShotDelay];
  }
  
  return self;
}

-(BOOL)readyToShoot {
  return (shotDelay <= 0 && shooting == 0);
}

-(GLKVector4)bulletColor {
  return GLKVector4Make(0.643, 0.776, 0.224, 1.0);
}

-(NSArray *)appendageNames {
  return [NSArray arrayWithObjects:@"left arm", @"right arm",nil];
}

-(NSArray *)namesOfNodesToFlash {
  return [NSArray arrayWithObjects:@"body", @"left arm", @"right arm",nil];
}

-(void)setupLegs {
  [children removeObject:[self childNamed:@"legs"]];
}

-(float)bulletInitialYOffset {
  return 0.5*scaleY;
}

-(void)emitBulletsInScene:(Game *)scene {
  [[TESoundManager sharedManager] play:@"shoot"];
  
  for (TENode *node in appendages)
    [self shootInDirection:GLKVector2Make(0,-1) inScene:scene xOffset:scaleX*node.position.x];
  
  [self resetShotDelay];
  shooting--;
}

-(void)shootInScene:(Game *)scene {
  if (![self ableToShootInScene:scene])
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
  
  TENode *legs = [self childNamed:@"legs"];
  if (legs != nil) {
    TETranslateAnimation *animation2 = [[TETranslateAnimation alloc] init];
    animation2.translation = GLKVector2Make(0, -0.15);
    animation2.reverse = YES;
    animation2.duration = 0.1;
    animation2.repeat = numShots-1;
    [legs startAnimation:animation2];
  }
}

-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene {
  [super update:dt inScene:scene];

  if (seekingDelay > 0)
    seekingDelay -= dt;
  if (seekingDelay <= 0)
    [self seekInScene:(Game*)scene];
  
  [self wraparoundInScene:scene];
}

-(void)seekInScene:(Game*)game {
  seekingLocation = GLKVector2Make(game.fighter.position.x+seekingOffset,[TERandom randomFractionFrom:(game.bottom+FRAY_ARMS_SEEKING_BOTTOM_OFFSET) to:(game.top-FRAY_ARMS_SEEKING_BOTTOM_OFFSET)]);
  seekingDelay = [TERandom randomFractionFrom:FRAY_ARMS_SEEKING_TIME_MIN to:FRAY_ARMS_SEEKING_TIME_MAX];
  self.velocity = GLKVector2DivideScalar(GLKVector2Subtract(seekingLocation, self.position),seekingDelay);
}

-(void)flashWhite {
  for (TENode *node in [self childrenNamed:[self namesOfNodesToFlash]]) {
    TEVertexColorAnimation *highlight = [[TEVertexColorAnimation alloc] initWithNode:node];
    for (int i = 0; i < node.shape.numVertices; i++)
      ((TEVertexColorAnimation*)highlight).toColorVertices[i] = GLKVector4Make(1, 1, 1, 1);
    highlight.duration = 0.2;
    highlight.backward = YES;

    [node startAnimation:highlight];
  }
}

@end
