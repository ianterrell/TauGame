//
//  Background.h
//  TauGame
//
//  Created by Ian Terrell on 7/31/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface Background : TECharacter {
  float time, radius;
}

- (id)initInScene:(TEScene *)scene;

@end
