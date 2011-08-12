//
//  TEMenu.h
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"
#import "TEButton.h"

@interface TEMenu : TEScene {
  NSMutableArray *buttons;
  TEButton *currentButton;
}

-(void)addButton:(TEButton*)button;

@end
