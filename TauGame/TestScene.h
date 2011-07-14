//
//  TestScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"
#import "TECharacter.h"

@interface TestScene : TEScene {
  TECharacter *mage, *obstacle;
  void *world, *mageBody, *obstacleBody;
}

@end
