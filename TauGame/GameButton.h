//
//  GameButton.h
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TEButton.h"

@interface GameButton : TEButton {
  TENode *glowNode;
}

-(id) initWithText:(NSString *)text;

@end
