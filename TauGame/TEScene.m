//
//  TEScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"
#import "TauEngine.h"

@implementation TEScene

@synthesize left, right, bottom, top;
@synthesize clearColor;
@synthesize characters;
@synthesize currentOrientation, orientationRotationMatrix;

- (id)init {
  self = [super init];
  if (self) {
    // OPTIMIZATION: configurable multisample
    self.frame = [[UIScreen mainScreen] bounds];
    self.delegate = self;
    self.drawableMultisample = GLKViewDrawableMultisample4X;
    self.characters = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
//  NSLog(@"FPS: %d, %f, %f", [controller framesPerSecond], [controller timeSinceLastDraw], [controller timeSinceLastUpdate]);
  GLfloat timeSince = [controller timeSinceLastDraw]; // FIXME should really be timeSinceLastUpdate, but it's buggy
  
  // Update positions
  for (id character in characters)
    [(TECharacter *)character updatePosition:timeSince];
  
  // Update animations
  [self.characters makeObjectsPerformSelector:@selector(traverseUsingBlock:) withObject:^(TENode *node) {
    // Remove animations that are done
    [node.currentAnimations filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id animation, NSDictionary *bindings) {
      return !((TEAnimation *)animation).remove;
    }]];
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop) {
      [((TEAnimation *)animation) incrementElapsedTime:timeSince];
    }];
  }];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self render];
}

# pragma mark Scene Setup

-(void)setLeft:(GLfloat)_left right:(GLfloat)_right bottom:(GLfloat)_bottom top:(GLfloat)_top {
  self.left = _left;
  self.right = _right;
  self.bottom = _bottom;
  self.top = _top;
}

-(float)width {
  return right-left;
}

-(float)height {
  return top-bottom;
}

-(GLKVector2)bottomLeftVisible {
  float offset = [self orientationOffset];
  return GLKVector2Make(left-offset, bottom+offset);
}

-(GLKVector2)topRightVisible {
  float offset = [self orientationOffset];
  return GLKVector2Make(right+offset, top-offset);
}

# pragma mark Orientation

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation {
  return orientation == UIDeviceOrientationLandscapeLeft;
}

-(void)orientationChangedTo:(UIDeviceOrientation)orientation {
  currentOrientation = orientation;
  GLKMatrix4 translation = GLKMatrix4MakeTranslation((left-right)/2.0, (bottom-top)/2.0, 0);
  GLKMatrix4 rotation = GLKMatrix4MakeZRotation([self turnsForOrientation]*M_TAU);
  GLKMatrix4 revertTranslation = GLKMatrix4MakeTranslation((right-left)/2.0, (top-bottom)/2.0, 0);
  orientationRotationMatrix = GLKMatrix4Multiply(revertTranslation, GLKMatrix4Multiply(rotation, translation));
}

-(float)turnsForOrientation {
  switch (currentOrientation) {
    case UIDeviceOrientationLandscapeLeft:
      return -0.25;
    case UIDeviceOrientationLandscapeRight:
      return 0.25;
    case UIDeviceOrientationPortraitUpsideDown:
      return 0.5;
    default:
      return 0.0;
  }
}

-(float)orientationOffset {
  float offset = 0.0;
  if (UIDeviceOrientationIsLandscape(currentOrientation))
    offset = (self.height-self.width)/2.0;
  return offset;
}

# pragma mark Rendering

-(void)render {
  glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [characters makeObjectsPerformSelector:@selector(renderInScene:) withObject:self];
}

- (GLKBaseEffect *)constantColorEffect {
  if (!constantColorEffect) {
    constantColorEffect = [[GLKBaseEffect alloc] init];
    constantColorEffect.useConstantColor = GL_TRUE;
  }
  return constantColorEffect;
}

-(GLKMatrix4)projectionMatrix {
  return GLKMatrix4MakeOrtho(left, right, bottom, top, 1.0, -1.0);
}

@end
