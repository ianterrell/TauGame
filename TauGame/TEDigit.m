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
static GLKBaseEffect *digitsTextureEffect;

@implementation TEDigit

@synthesize digit;

+(void)initialize {
  NSError *error;
  digitsTexture = [GLKTextureLoader textureWithCGImage:[TEImage imageFromText:@"0123456789"].CGImage options:nil error:&error];
  if (error) {
    NSLog(@"Error making digits texture: %@",error);
  }
  
  digitsTextureEffect = [[GLKBaseEffect alloc] init];
  digitsTextureEffect.texturingEnabled = YES;
  digitsTextureEffect.texture2d0.envMode = GLKTextureEnvModeReplace;
  digitsTextureEffect.texture2d0.target = GLKTextureTarget2D;
  digitsTextureEffect.texture2d0.glName = digitsTexture.glName;
}

- (id)init
{
  self = [super init];
  if (self) {
    effect = digitsTextureEffect;
    digit = 0;
    renderStyle = kTERenderStyleTexture;
    color = GLKVector4Make(1,0,0,0);
    
    // TODO: set to digit, hurray!
    self.textureCoordinates[0] = GLKVector2Make(1, 0);
    self.textureCoordinates[1] = GLKVector2Make(1, 1);
    self.textureCoordinates[2] = GLKVector2Make(0, 1);
    self.textureCoordinates[3] = GLKVector2Make(0, 0);
  }
  
  return self;
}

@end
