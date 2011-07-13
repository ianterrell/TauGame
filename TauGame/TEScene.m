//
//  TEScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"
#import "TENode.h"
#import "TEAnimation.h"

@implementation TEScene

@synthesize left, right, bottom, top;
@synthesize clearColor;
@synthesize characters;

- (id)init {
  self = [super init];
  if (self) {
    self.characters = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
//  NSLog(@"FPS: %d, %f", [controller framesPerSecond], [controller timeSinceLastDraw]);
  GLfloat timeSince = [controller timeSinceLastDraw]; // FIXME should really be timeSinceLastUpdate, but it's buggy
  
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
