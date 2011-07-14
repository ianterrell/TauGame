//
//  TestScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauGameAppDelegate.h"
#import "TestScene.h"
#import "TECharacterLoader.h"
#import "Box2D.h"

@implementation TestScene

- (id)init {
  self = [super init];
  if (self) {
    [self setLeft:-6.4 right:6.4 bottom:-8.53 top:8.53];
    clearColor = GLKVector4Make(0.5, 0.6, 0.5, 0.5);
    mage = [TECharacterLoader loadCharacterFromJSONFile:@"mage"];
    [characters addObject:mage];
    
    obstacle = [TECharacterLoader loadCharacterFromJSONFile:@"obstacle"];
//    [characters addObject:obstacle];
    
    
    // Box2d experimentation for collision detection
    
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = false;
    world = new b2World(gravity, doSleep);
    
    b2BodyDef mageBodyDef;
    mageBodyDef.type = b2_dynamicBody;
    mageBodyDef.position.Set(mage.translation.x, mage.translation.y);
//    mageBodyDef.userData = (void*)mage;
    mageBody = ((b2World*)world)->CreateBody(&mageBodyDef);
    
    b2PolygonShape mageShape;
    mageShape.SetAsBox(2.0, 2.0);
    b2FixtureDef mageShapeDef;
    mageShapeDef.shape = &mageShape;
    mageShapeDef.density = 10.0;
    mageShapeDef.isSensor = true;
    ((b2Body *)mageBody)->CreateFixture(&mageShapeDef);
    
    b2BodyDef obstacleBodyDef;
    obstacleBodyDef.type = b2_dynamicBody;
    obstacleBodyDef.position.Set(obstacle.translation.x, obstacle.translation.y);
    //    obstacleBodyDef.userData = (void*)obstacle;
    obstacleBody = ((b2World*)world)->CreateBody(&obstacleBodyDef);
    
    b2PolygonShape obstacleShape;
    obstacleShape.SetAsBox(0.3, 0.3);
    b2FixtureDef obstacleShapeDef;
    obstacleShapeDef.shape = &obstacleShape;
    obstacleShapeDef.density = 10.0;
    obstacleShapeDef.isSensor = true;
    ((b2Body *)obstacleBody)->CreateFixture(&obstacleShapeDef);
  }
  
  return self;
}

-(void)glkViewControllerUpdate:(GLKViewController *)controller {
//  NSLog(@"Stuff: %@", ((TauGameAppDelegate *)[UIApplication sharedApplication].delegate).motionManager.deviceMotion);
  //  CMAcceleration accel = ((TauGameAppDelegate *)[UIApplication sharedApplication].delegate).motionManager.deviceMotion.userAcceleration;
  CMAttitude *attitude = ((TauGameAppDelegate *)[UIApplication sharedApplication].delegate).motionManager.deviceMotion.attitude;
//  NSLog(@"Roll %f, pitch %f, yaw %f", attitude.roll, attitude.pitch, attitude.yaw);

  float x = mage.translation.x + attitude.roll;
  float y = mage.translation.y - attitude.pitch;
  
  if (x > right)
    x = left;
  else if (x < left)
    x = right;
  if (y > top)
    y = bottom;
  else if (y < bottom)
    y = top;
  
  mage.translation = GLKVector2Make(x, y);
  [super glkViewControllerUpdate:controller];
}

@end

// Other options:

//  int turns[] = {-2,-1,1,2};
//  int row = 3, col = 4;
//  float space = 6.4*2/row;
//  for (int i = 0; i < row; i++) {
//    for (int j = 0; j < col; j++) {
//      TECharacter *mage = [TECharacterLoader loadCharacterFromJSONFile:@"mage"];
//      mage.scale = 0.4;
//      mage.translation = GLKVector2Make(-6.4 + i*space, -8.3 + j*space);
//      
//      TEScaleAnimation *grow = [[TEScaleAnimation alloc] init];
//      grow.scale = 3*((float)arc4random())/RAND_MAX;
//      grow.duration = 5*((float)arc4random())/RAND_MAX;;
//      grow.repeat = TEAnimationRepeatForever;
//      [mage.currentAnimations addObject:grow];
//      
//      TERotateAnimation *spin = [[TERotateAnimation alloc] init];
//      spin.rotation = turns[arc4random() % 4]*M_TAU;
//      spin.duration = 5*((float)arc4random())/RAND_MAX;;
//      spin.repeat = TEAnimationRepeatForever;
//      [mage.currentAnimations addObject:spin];
//      
//      [scene.characters addObject:mage];
//    }
//  }


//  TEAnimation *grow = [[TEAnimation alloc] init];
//  grow.type = TEAnimationScale;
//  grow.value0 = 1.5;
//  grow.duration = 2.0;
//  [mage.currentAnimations addObject:grow];
//  
//  TEAnimation *spin = [[TEAnimation alloc] init];
//  spin.type = TEAnimationRotate;
//  spin.value0 = M_TAU;
//  spin.duration = 2.0;
//  spin.repeat = 1;
//  [mage.currentAnimations addObject:spin];
//  
//  [mage traverseUsingBlock:^(TENode *node){
//    NSLog(@"Node %@ has %d animations", node.name, [node.currentAnimations count]);
//  }];

//  TECharacter *mage2 = [TECharacterLoader loadCharacterFromJSONFile:@"mage"];
//  mage2.scale = 0.5;
//  mage2.translation = GLKVector2Make(-3.0, -3.0);
//  mage2.rotation = 0.25*M_TAU;
//  [scene.characters addObject:mage2];
//  
//  TECharacter *mage3 = [TECharacterLoader loadCharacterFromJSONFile:@"mage"];
//  mage3.scale = 2;
//  mage3.translation = GLKVector2Make(3.0, 3.0);
//  mage3.rotation = -0.5*M_TAU;
//  [scene.characters addObject:mage3];
