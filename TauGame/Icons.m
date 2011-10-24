//
//  Icons.m
//  TauGame
//
//  Created by Ian Terrell on 10/24/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Icons.h"
#import "GameController.h"
#import "Fighter.h"
#import "HordeUnit.h"
#import "BigHordeUnit.h"
#import "GlowingBullet.h"

@implementation Icons

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Set up coordinates
    CGSize parentSize = frame.size;
    float extraScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 1;
    [self setLeft:0 right:parentSize.height/(extraScale*POINT_RATIO) bottom:0 top:parentSize.width/(extraScale*POINT_RATIO)]; // not sure why container isn't sized properly
    
    // Set up background
    [[GameController sharedController] setupBackgroundIn:self];
    
    Fighter *fighter = [[Fighter alloc] init];
    fighter.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2 + 1, self.bottomLeftVisible.y + 0.75);
    fighter.scale = 2.3;
    [characters addObject:fighter];
    
    GlowingBullet *fighterBullet = [[GlowingBullet alloc] initWithColor:GLKVector4Make(1,1,1,1)];
    fighterBullet.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2 + 1, self.bottomLeftVisible.y + 3.75);
    fighterBullet.scale = 2.3;
    [characters addObject:fighterBullet];
    
    
    
    BigHordeUnit *centerUnit = [[BigHordeUnit alloc] init];
    [HordeUnit colorizeUnit:centerUnit index:0];
    centerUnit.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2, self.topRightVisible.y);
    centerUnit.scale = 2.1;
    [characters addObject:centerUnit];
    
    BigHordeUnit *leftUnit = [[BigHordeUnit alloc] init];
    [HordeUnit colorizeUnit:leftUnit index:5];
    leftUnit.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2 - 2.3, self.topRightVisible.y);
    leftUnit.scale = 2.1;
    [characters addObject:leftUnit];
    
    GlowingBullet *baddieBullet = [[GlowingBullet alloc] initWithColor:GLKVector4Make(1,0,1,1)];
    baddieBullet.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2 - 2.3, self.bottomLeftVisible.y + 2.25);
    baddieBullet.scale = 2.1;
    [characters addObject:baddieBullet];
    
    
    BigHordeUnit *rightUnit = [[BigHordeUnit alloc] init];
    [HordeUnit colorizeUnit:rightUnit index:2];
    rightUnit.position = GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2 + 2.3, self.topRightVisible.y);
    rightUnit.scale = 2.1;
    [characters addObject:rightUnit];
  }
  
  return self;
}
@end
