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

- (id)init {
  self = [super init];
  if (self) {
    // OPTIMIZATION: configurable multisample
    
//    self.autoresizingMask = 
    self.frame = [[UIScreen mainScreen] bounds];
    self.delegate = self;
    self.drawableMultisample = GLKViewDrawableMultisample4X;
    self.characters = [[NSMutableArray alloc] init];
    
    dirtyProjectionMatrix = YES;
  }
  
  return self;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
  GLfloat timeSince = [controller timeSinceLastDraw]; // FIXME should really be timeSinceLastUpdate, but it's buggy
  
  // Update all characters
  for (TECharacter *character in characters)
    [character update:timeSince inScene:self];

  // Remove any who declared they need removed
  NSMutableArray *removed = [[NSMutableArray alloc] init];
  [characters filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TECharacter *character, NSDictionary *bindings) {
    if (character.remove) {
      [removed addObject:character];
      return NO;
    } else
      return YES;
  }]];
  for (TECharacter *character in removed) {
    [self nodeRemoved:character];
    [character onRemoval];
  }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self render];
}

# pragma mark Scene Setup

-(void)setLeft:(GLfloat)_left right:(GLfloat)_right bottom:(GLfloat)_bottom top:(GLfloat)_top {
  left = _left;
  right = _right;
  bottom = _bottom;
  top = _top;
  dirtyProjectionMatrix = YES;
  [self markChildrensFullMatricesDirty];
}

-(float)width {
  return right-left;
}

-(float)height {
  return top-bottom;
}

-(float)visibleWidth {
  return self.topRightVisible.x - self.bottomLeftVisible.x;
}

-(float)visibleHeight {
  return self.topRightVisible.y - self.bottomLeftVisible.y;
}

-(GLKVector2)bottomLeftVisible {
  return GLKVector2Make(left, bottom);
}

-(GLKVector2)topRightVisible {
  return GLKVector2Make(right, top);
}

# pragma mark Orientation

-(BOOL)orientationSupported:(UIInterfaceOrientation)orientation {
  return UIInterfaceOrientationIsLandscape(orientation);
}

# pragma mark Rendering

-(void)markChildrensFullMatricesDirty {
  [characters makeObjectsPerformSelector:@selector(traverseUsingBlock:) withObject:^(TENode *node) {
    node.dirtyFullModelViewMatrix = YES;
  }];
}

-(void)render {
  glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [characters makeObjectsPerformSelector:@selector(renderInScene:) withObject:self];
}

-(GLKMatrix4)projectionMatrix {
  if (dirtyProjectionMatrix) {
    cachedProjectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1.0, -1.0);
    dirtyProjectionMatrix = NO;
  }
  return cachedProjectionMatrix;
}

# pragma mark Scene Updating

-(void)nodeRemoved:(TENode *)node {
}


@end
