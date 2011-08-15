//
//  Sfx.m
//  TauGame
//
//  Created by Ian Terrell on 8/15/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Sfx.h"
#import "TEShuffleBag.h"
#import "TESoundManager.h"

@implementation Sfx

TEShuffleBag *shootBag, *hurtBag, *baddieShootBag, *baddieHurtBag, *baddieDieBag;
NSString *dieSound, *resurrectSound, *baddieDropSound, *baddieInvulnerableSound, *scoreBonusSound, *powerupSound;

+(void)loadSounds:(NSArray *)sounds {
  for (NSString *sound in sounds)
    [[TESoundManager sharedManager] load:sound];
}

+(void)initialize {
  NSArray *shootSounds = [NSArray arrayWithObjects:@"shoot0", @"shoot1", @"shoot2", nil];
  shootBag = [[TEShuffleBag alloc] initWithItems:shootSounds autoReset:YES];
  [self loadSounds:shootSounds];
  
  NSArray *hurtSounds = [NSArray arrayWithObjects:@"f-hurt0", @"f-hurt1", @"f-hurt2", nil];
  hurtBag = [[TEShuffleBag alloc] initWithItems:hurtSounds autoReset:YES];
  [self loadSounds:hurtSounds];
  
  NSArray *dieSounds = [NSArray arrayWithObject:@"die"];
  dieSound = [dieSounds objectAtIndex:0];
  [self loadSounds:dieSounds];
  
  NSArray *resurrectSounds = [NSArray arrayWithObject:@"resurrect"];
  resurrectSound = [resurrectSounds objectAtIndex:0];
  [self loadSounds:resurrectSounds];
  
  NSArray *baddieShootSounds = [NSArray arrayWithObjects:@"bad0", @"bad1", @"bad2", @"bad3", nil];
  baddieShootBag = [[TEShuffleBag alloc] initWithItems:baddieShootSounds autoReset:YES];
  [self loadSounds:baddieShootSounds];
  
  NSArray *baddieDropSounds = [NSArray arrayWithObject:@"drop"];
  baddieDropSound = [baddieDropSounds objectAtIndex:0];
  [self loadSounds:baddieDropSounds];
  
  NSArray *baddieInvulnerableSounds = [NSArray arrayWithObject:@"invulnerable"];
  baddieInvulnerableSound = [baddieInvulnerableSounds objectAtIndex:0];
  [self loadSounds:baddieInvulnerableSounds];
  
  NSArray *baddieHurtSounds = [NSArray arrayWithObjects:@"hurt0", @"hurt1", @"hurt2", @"hurt3", nil];
  baddieHurtBag = [[TEShuffleBag alloc] initWithItems:baddieHurtSounds autoReset:YES];
  [self loadSounds:baddieHurtSounds];
  
  NSArray *baddieDieSounds = [NSArray arrayWithObjects:@"bdie0", @"bdie1", @"bdie2", nil];
  baddieDieBag = [[TEShuffleBag alloc] initWithItems:baddieDieSounds autoReset:YES];
  [self loadSounds:baddieDieSounds];
  
  NSArray *scoreBonusSounds = [NSArray arrayWithObjects:@"scorebonus", nil];
  scoreBonusSound = [scoreBonusSounds objectAtIndex:0];
  [self loadSounds:scoreBonusSounds];
  
  NSArray *powerupSounds = [NSArray arrayWithObjects:@"powerup", nil];
  powerupSound = [powerupSounds objectAtIndex:0];
  [self loadSounds:powerupSounds];
}

+(void)shoot{
  [[TESoundManager sharedManager] play:[shootBag drawItem]];
}

+(void)hurt{
  [[TESoundManager sharedManager] play:[hurtBag drawItem]];
}

+(void)die{
  [[TESoundManager sharedManager] play:dieSound];
}

+(void)resurrect{
  [[TESoundManager sharedManager] play:resurrectSound];
}

+(void)baddieShoot{
  [[TESoundManager sharedManager] play:[baddieShootBag drawItem]];
}

+(void)baddieDrop{
  [[TESoundManager sharedManager] play:baddieDropSound];
}

+(void)baddieInvulnerable{
  [[TESoundManager sharedManager] play:baddieInvulnerableSound];
}

+(void)baddieHurt{
  [[TESoundManager sharedManager] play:[baddieHurtBag drawItem]];
}

+(void)baddieDie{
  [[TESoundManager sharedManager] play:[baddieDieBag drawItem]];
}

+(void)scoreBonus{
  [[TESoundManager sharedManager] play:scoreBonusSound];
}

+(void)powerup{
  [[TESoundManager sharedManager] play:powerupSound];
}



@end
