//
//  StarfieldLayer.h
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface StarfieldLayer : TENode {
  float layerVelocity, width, height;
}

@property float layerVelocity;

-(id)initWithWidth:(float)width height:(float)height pixelRatio:(float)pixelRatio numStars:(int)numStars;
+(UIImage *)starfieldImageWithStars:(int)num width:(int)width height:(int)height;

@end

@interface StarfieldLayerShape : TEPolygon

-(id)initWithWidth:(float)width height:(float)height textureImage:(UIImage *)image;

@end