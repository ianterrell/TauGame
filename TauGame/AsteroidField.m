//
//  AsteroidField.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "AsteroidField.h"

@implementation AsteroidField

- (id)init
{
  self = [super init];
  if (self) {
    // Set up coordinates
    [self setLeft:0 right:8 bottom:0 top:12];
    [self orientationChangedTo:UIDeviceOrientationLandscapeLeft];
    
    // Set up background
    clearColor = GLKVector4Make(0, 0, 0, 1);

    [self newAsteroid];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newAsteroid)];
    [self addGestureRecognizer:tapRecognizer];
  }
  
  return self;
}

-(BOOL)orientationSupported:(UIDeviceOrientation)orientation {
  return orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight;
}

-(void)orientationChangedTo:(UIDeviceOrientation)orientation {
  [super orientationChangedTo:orientation];
}
-(float)point {
  return 0.5+((float)rand()/RAND_MAX);
}
-(void)newAsteroid {
  [characters removeAllObjects];
  
  Asteroid *asteroid = [[Asteroid alloc] init];
  for (int i = 0; i < 5; i++) {
    TENode *triangleNode = [[TENode alloc] init];
    TETriangle *triangleShape = [[TETriangle alloc] init];
    
    triangleShape.color = GLKVector4Make(1, 1, 1, 1);
    triangleShape.vertex0 = GLKVector2Make(0, [self point]);
    triangleShape.vertex1 = GLKVector2Make(-1*[self point], 0);
    triangleShape.vertex2 = GLKVector2Make([self point], 0);
    triangleShape.parent = triangleNode;

    triangleNode.shape = triangleShape;
    triangleNode.parent = asteroid;
    triangleNode.rotation = ((float)rand()/RAND_MAX)*M_TAU;
    [asteroid.children addObject:triangleNode];
  }

  asteroid.position = GLKVector2Make(6, 4);//(self.topRightVisible.x - self.bottomLeftVisible.x)/2.0, (self.topRightVisible.y - self.bottomLeftVisible.y)/2.0);
  asteroid.scale = MAX(0.25,((float)rand()/RAND_MAX));
  [characters addObject:asteroid];
}


@end

