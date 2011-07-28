//
//  TEDigit.m
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDigit.h"
#import "TEImage.h"

static GLKTextureInfo *digitsTexture;

@implementation TEDigit

@synthesize digit;

+(void)initialize {
  NSError *error;
  digitsTexture = [GLKTextureLoader textureWithCGImage:[TEImage imageFromText:@"0123456789"].CGImage options:nil error:&error];
  if (error) {
    NSLog(@"Error making digits texture: %@",error);
  }
}

- (id)init
{
  self = [super init];
  if (self) {
    digit = 0;
    renderStyle = kTERenderStyleTexture;
  }
  
  return self;
}

-(void)renderInScene:(TEScene *)scene forNode:(TENode *)node  {
  [super renderInScene:scene forNode:node];
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  glDrawArrays([self renderMode], 0, [self numVertices]);
  glDisableVertexAttribArray(GLKVertexAttribPosition);
}


@end
