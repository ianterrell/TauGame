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

static float digitFractionalWidth;

@implementation TEDigit

+(void)initialize {
  UIFont *font = [UIFont fontWithName:@"Courier-Bold" size:30];
  
  NSError *error;
  digitsTexture = [GLKTextureLoader textureWithCGImage:[TEImage imageFromText:@"0123456789" withFont:font].CGImage options:nil error:&error];
  if (error) {
    NSLog(@"Error making digits texture: %@",error);
  }
  
  float digitWidth = [@"0" sizeWithFont:font].width - 1.0; // pads by 1 px on end
  digitFractionalWidth = digitWidth / (10*digitWidth + 1.0);
  
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
    self.digit = 0;
    
    renderStyle = kTERenderStyleTexture;
  }
  
  return self;
}

-(int)digit {
  return digit;
}

-(void)setDigit:(int)_digit {
  digit = _digit;

  self.textureCoordinates[0] = GLKVector2Make((digit+1)*digitFractionalWidth, 0);
  self.textureCoordinates[1] = GLKVector2Make((digit+1)*digitFractionalWidth, 1);
  self.textureCoordinates[2] = GLKVector2Make(digit*digitFractionalWidth, 1);
  self.textureCoordinates[3] = GLKVector2Make(digit*digitFractionalWidth, 0);
}

@end
