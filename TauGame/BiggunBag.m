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

@implementation BiggunBag

-(void)reset {
  [super setItems:[NSArray arrayWithObjects:[BigHordeUnit class], [BigArms class], nil]];
}

@end
