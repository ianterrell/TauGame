//
//  TENode.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"
#import "TEShape.h"

@interface TENode : TEDrawable {
  NSString *name;
  TEShape *shape;
  NSMutableArray *children;
}

@end
