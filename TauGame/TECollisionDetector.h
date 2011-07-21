//
//  TECollisionDetector.h
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TauEngine.h"

@interface TECollisionDetector : NSObject

+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2;

+(NSMutableArray *)collisionsIn:(NSArray *)nodes;
+(NSMutableArray *)collisionsIn:(NSArray *)nodes maxPerNode:(int)n;

@end
