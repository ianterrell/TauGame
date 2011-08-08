//
//  TEShuffleBag.h
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEShuffleBag : NSObject {
  NSMutableArray *bag;
}

-(id)initWithItems:(NSArray *)items;
-(void)setItems:(NSArray *)items;
-(id)drawItem;

@end
