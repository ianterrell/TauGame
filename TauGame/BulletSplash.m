//
//  BulletSplash.m
//  TauGame
//
//  Created by Ian Terrell on 7/29/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "BulletSplash.h"
#import "TauEngine.h"

@implementation BulletSplash

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"bullet-splash"];
    self.scale = 1;
    
    BOOL setRemovedCallback = NO;
    for (TENode *child in children) {
      TETranslateAnimation *translateAnimation = [[TETranslateAnimation alloc] init];
      translateAnimation.translation = GLKVector2Make([TERandom randomFractionFrom:-0.5 to:0.5], [TERandom randomFractionFrom:-0.8 to:0.2]);
      translateAnimation.duration = 0.1;
      if (!setRemovedCallback) {
        translateAnimation.onRemoval= ^(){
          self.remove = YES;
        };
        setRemovedCallback = YES;
      }
      [child.currentAnimations addObject:translateAnimation];
    }
  }

  return self;
}

@end
