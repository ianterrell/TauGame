//
//  TECharacter.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"

@interface TECharacter : NSObject {
  NSString *name;
  TENode *rootNode;
  GLKVector2 position;
}

@end
