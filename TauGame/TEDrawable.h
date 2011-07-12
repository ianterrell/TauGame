//
//  TEDrawable.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TEDrawable : NSObject {
  GLKVector2 translation;
  GLfloat scale;
  GLfloat rotation;
}

-(void)render;

@end
