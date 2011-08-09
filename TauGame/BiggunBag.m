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

@implementation BiggunBag

-(void)reset {
  [super setItems:[NSArray arrayWithObjects:[BigHordeUnit class], [BigArms class], nil]];
}

#ifdef DEBUG_BIGGUN
-(id)drawItem {
  return DEBUG_BIGGUN;
}
#endif

@end
