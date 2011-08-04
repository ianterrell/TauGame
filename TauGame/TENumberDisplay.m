//
//  TENumberDisplay.m
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENumberDisplay.h"
#import "TauEngine.h"


static GLKBaseEffect *digitsTextureEffect;

static CGSize digitSize;
static float digitFractionalWidth;

@implementation TENumberDisplay

@synthesize numDigits;

+(void)initialize {
  UIFont *font = [UIFont fontWithName:@"Courier-Bold" size:30];
  
  digitsTextureEffect = [TETexture effectWithTextureFromImage:[TEImage imageFromText:@"0123456789" withFont:font color:[UIColor blackColor]]];
  
  digitSize = [@"0" sizeWithFont:font];
  digitSize = CGSizeMake(digitSize.width-1.0, digitSize.height); // pads by 1 px on end
  digitFractionalWidth = digitSize.width / (10*digitSize.width + 1.0);
}

- (id)initWithNumDigits:(int)num
{
  self = [super initWithVertices:num*4];
  if (self) {
    effect = digitsTextureEffect;
    renderStyle = kTERenderStyleTexture;
    color = GLKVector4Make(0,1,0,1);
    numDigits = num;
    self.width = numDigits;
    self.number = 0;
  }
  
  return self;
}

-(void)updateVertices {
  float digitWidth = width / numDigits;
  float digitHeight = digitSize.height * (digitWidth/digitSize.width);
  
  float offset = numDigits % 2 == 0 ? 0 : digitWidth / 2.0;
  int middle = numDigits / 2;
  float top = digitHeight/2;
  float bottom = -1*top;
  
  for (int i = 0; i < numDigits; i++) {
    float left = -1*(middle-i)*digitWidth - offset;
    float right = left + digitWidth;
    
    int index = i*4;
    self.vertices[index+0] = GLKVector2Make(left, top);
    self.vertices[index+1] = GLKVector2Make(left, bottom);
    self.vertices[index+2] = GLKVector2Make(right, top);
    self.vertices[index+3] = GLKVector2Make(right, bottom);
  }
}

-(void)updateTextureCoordinates {
  for(int i = 0, temp = number; i < numDigits; ++i, temp /= 10 ) {
    int index = (numDigits-i-1)*4;
    int digit = temp-10*(temp/10);
    
    self.textureCoordinates[index+0] = GLKVector2Make(digit*digitFractionalWidth, 1);
    self.textureCoordinates[index+1] = GLKVector2Make(digit*digitFractionalWidth, 0);
    self.textureCoordinates[index+2] = GLKVector2Make((digit+1)*digitFractionalWidth, 1);
    self.textureCoordinates[index+3] = GLKVector2Make((digit+1)*digitFractionalWidth, 0);
  }
}

-(GLenum)renderMode {
  return GL_TRIANGLE_STRIP;
}

-(int)number {
  return number;
}

-(void)setNumber:(int)_number {
  number = _number;
  [self updateTextureCoordinates];
}

-(float)height {
  return digitSize.height * ((width/numDigits)/digitSize.width);
}

-(float)width {
  return width;
}

-(void)setWidth:(float)_width {
  width = _width;
  [self updateVertices];
}

@end
