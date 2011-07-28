//
//  ExtraBullet.m
//  TauGame
//
//  Created by Ian Terrell on 7/27/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "ExtraBullet.h"

@implementation ExtraBullet

- (id)init
{
  self = [super init];
  if (self) {
    [TECharacterLoader loadCharacter:self fromJSONFile:@"extra-bullet-powerup"];
    
    self.shape.renderStyle = kTERenderStyleVertexColors;
    self.shape.colorVertices[0] = GLKVector4Make(0.8,0.8,0,1);
    for (int i = 1; i < self.shape.numVertices; i++)
      self.shape.colorVertices[i] = GLKVector4Make(0, 0.6, 0, 1);
  }
  
  return self;
}

@end
