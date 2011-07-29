//
//  Starfield.h
//  TauGame
//
//  Created by Ian Terrell on 7/29/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface Starfield : TENode
- (id)initInScene:(TEScene *)scene;
@end

@interface StarfieldShape : TEShape {
  float width, height;
}

@property float width, height;

-(void)initVertices;
-(void)updateStarPositions:(NSTimeInterval)dt;

@end
