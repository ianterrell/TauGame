//
//  WeaponPowerupBag.m
//  TauGame
//
//  Created by Ian Terrell on 8/11/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "WeaponPowerupBag.h"

#import "ExtraShot.h"
#import "ExtraBullet.h"

@implementation WeaponPowerupBag

-(id)init {
  self = [super initWithItems:[NSArray arrayWithObjects:[ExtraShot class], [ExtraBullet class], nil] autoReset:YES];
  return self;
}

@end
