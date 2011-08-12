//
//  TEMenu.m
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TEMenu.h"
#import "TECollisionDetector.h"

@implementation TEMenu

-(id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    buttons = [NSMutableArray arrayWithCapacity:5];
    
  }
  return self;
}

-(void)addButton:(TEButton *)button {
  [characters addObject:button];
  [buttons addObject:button];
}

-(void)tap {
  NSLog(@"tapped!");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  currentButton = nil;
  UITouch *touch = [touches anyObject];
  GLKVector2 location = [self positionForLocationInView:[touch locationInView:self.view]];
  [buttons enumerateObjectsUsingBlock:^(TEButton *button, NSUInteger idx, BOOL *stop) {
    if ([TECollisionDetector point:location collidesWithNode:button]) {
      currentButton = button;
      [button highlight];
      *stop = YES;
    }
  }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if (currentButton) {
    UITouch *touch = [touches anyObject];
    GLKVector2 location = [self positionForLocationInView:[touch locationInView:self.view]];
    if (![TECollisionDetector point:location collidesWithNode:currentButton]) {
      [currentButton unhighlight];
      currentButton = nil;
    }
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  if (currentButton) {
    [currentButton unhighlight];
    currentButton = nil;
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (currentButton != nil) {
    [currentButton unhighlight];
    [currentButton fire];
    currentButton = nil;
  }
}

@end
