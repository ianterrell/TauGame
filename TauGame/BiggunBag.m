//
//  BiggunBag.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "BiggunBag.h"
#import "BigHordeUnit.h"
#import "BigArms.h"
#import "BigSeeker.h"
#import "BigSpinner.h"

@implementation BiggunBag

-(id)init {
  self = [super initWithItems:[NSArray arrayWithObjects:[BigHordeUnit class], [BigArms class], [BigSeeker class], [BigSpinner class], nil] autoReset:YES];
  return self;
}

#ifdef DEBUG_BIGGUN
-(id)drawItem {
  return DEBUG_BIGGUN;
}
#endif

@end
