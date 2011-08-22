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
-(id) initWithText:(NSString *)text font:(UIFont*)font;

-(id) initWithText:(NSString *)text touchScale:(GLKVector2)scale;
-(id) initWithText:(NSString *)text font:(UIFont*)font touchScale:(GLKVector2)scale;

@end
