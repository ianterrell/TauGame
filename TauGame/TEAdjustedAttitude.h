//
//  TEAdjustedAttitude.h
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TauEngine.h"

@interface TEAdjustedAttitude : NSObject {
  CMAttitude *referenceAttitude, *realAttitude, *adjustedAttitude;
}

@property(strong) CMAttitude *referenceAttitude;
@property(strong) CMAttitude *realAttitude;
@property(strong) CMAttitude *adjustedAttitude;

@property(readonly) float roll;
@property(readonly) float pitch;
@property(readonly) float yaw;

-(void)update;
-(void)zero;

@end
