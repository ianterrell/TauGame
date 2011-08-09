//
//  BigSpinner.h
//  TauGame
//
//  Created by Ian Terrell on 8/9/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "Spinner.h"

@interface BigSpinner : Spinner {
  Spinner *leftSlave, *rightSlave;
}

@property(strong,readonly) Spinner *leftSlave, *rightSlave;

@end
