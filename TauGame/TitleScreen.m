//
//  MainMenuViewController.m
//  TauGame
//
//  Created by Ian Terrell on 7/22/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "GameController.h"
#import "TitleScreen.h"
#import "Background.h"
#import "Starfield.h"
#import "Game.h"

@implementation TitleScreen

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Set up coordinates
    CGSize parentSize = frame.size;
    [self setLeft:0 right:parentSize.height/POINT_RATIO bottom:0 top:parentSize.width/POINT_RATIO]; // not sure why container isn't sized properly
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);
    [characters addObject:[[Background alloc] initInScene:self]];
    [Starfield addDefaultStarfieldWithWidth:self.width height:self.height pixelRatio:POINT_RATIO toScene:self];
        
//    layer = [[StarfieldLayer alloc] initWithWidth:self.width height:self.height pixelRatio:POINT_RATIO numStars:500];
//    layer.position = GLKVector2Make(0,0);
//    [characters insertObject:layer atIndex:0];
//    
//    layer = [[StarfieldLayer alloc] initWithWidth:self.width height:self.height pixelRatio:POINT_RATIO numStars:500];
//    layer.position = GLKVector2Make(0,0);
//    [characters insertObject:layer atIndex:0];
    
    // Set up starting
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:64];
    TESprite *title = [[TESprite alloc] initWithImage:[TEImage imageFromText:@"GALAXY WILD" withFont:font color:[UIColor whiteColor]] pointRatio:POINT_RATIO];
    TENode *titleNode = [TENode nodeWithDrawable:title];
    titleNode.scaleX = 0.9;
    titleNode.scaleY = 0.5;
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
  [[GameController sharedController] addSceneOfClass:[Game class] named:@"game"];
  [[GameController sharedController] displayScene:@"game"];
}

@end
