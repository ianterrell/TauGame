//
//  ShotTimer.h
//  TauGame
//
//  Created by Ian Terrell on 8/1/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface ShotTimer : TECharacter {
  TENode *bar;
}

-(BOOL)ready;
-(void)fireWithTime:(float)time;

@end
