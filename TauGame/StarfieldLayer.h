//
//  StarfieldLayer.h
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface StarfieldLayer : TENode {
  int numStars;
  float layerVelocity, width, height;
}

@property int numStars;
@property float layerVelocity, width, height;

@end

@interface StarfieldLayerShape : TEPolygon

@end