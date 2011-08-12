//
//  TEButton.h
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"

@interface TEButton : TENode {
  id object;
  SEL action;
}

@property(strong) id object;
@property SEL action;

+(TEButton *)buttonWithDrawable:(TEDrawable *)drawable;

-(void)highlight;
-(void)unhighlight;
-(void)fire;

@end
