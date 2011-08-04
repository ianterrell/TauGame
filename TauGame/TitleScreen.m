//
//  MainMenuViewController.m
//  TauGame
//
//  Created by Ian Terrell on 7/22/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TitleScreen.h"
#import "Background.h"
#import "StarfieldLayer.h"
#import "AsteroidField.h"

#define POINT_RATIO 40

@implementation TitleScreen

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    CGSize parentSize = [TESceneController sharedController].container.frame.size;
    [self setLeft:0 right:parentSize.width/POINT_RATIO bottom:0 top:parentSize.height/POINT_RATIO];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    [characters insertObject:[[Background alloc] initInScene:self] atIndex:0];
    
    StarfieldLayer *layer = [[StarfieldLayer alloc] initWithWidth:self.width height:self.height pixelRatio:POINT_RATIO numStars:500];
    layer.position = GLKVector2Make(0,0);
    [characters insertObject:layer atIndex:1];
    
    // Set up starting
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:32];
    TESprite *title = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"GALAXY WILD" withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
    TENode *titleNode = [TENode nodeWithDrawable:title];
    titleNode.position = GLKVector2Make(self.width/2,self.height/2);
    [characters addObject:titleNode];
    
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:12];
    TESprite *tapToPlay = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"tap to play" withFont:font2 color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
    TENode *tapToPlayNode = [TENode nodeWithDrawable:tapToPlay];
    tapToPlayNode.position = GLKVector2Make(self.width/2,self.height/2-0.75);
    TEScaleAnimation *animation = [[TEScaleAnimation alloc] init];
    animation.scale = 1.2;
    animation.duration = 0.5;
    animation.reverse = YES;
    animation.repeat = kTEAnimationRepeatForever;
    [tapToPlayNode.currentAnimations addObject:animation];
    [characters addObject:tapToPlayNode];
  }
  
  return self;
}


-(void)play {
  [TEAccelerometer zero];
  [[TESceneController sharedController] removeScene:@"baddies"];
  [[TESceneController sharedController] addScene:[[AsteroidField alloc] init] named:@"baddies"];
  [[TESceneController sharedController] displayScene:@"baddies"];
}

@end
