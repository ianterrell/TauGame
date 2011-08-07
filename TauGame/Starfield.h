//
//  StarfieldLayer.h
//  TauGame
//
//  Created by Ian Terrell on 8/3/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"

@interface Starfield : NSObject {
  NSMutableArray *layers;
}

+(void)addDefaultStarfieldWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio toScene:(TEScene *)scene;
+(Starfield *)defaultStarfieldWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio;
-(id)initWithWidth:(float)_width height:(float)_height pixelRatio:(float)pixelRatio layers:(NSArray *)layerDescriptions;
-(NSArray *)layers;

@end

@interface StarfieldLayer : TENode {
  float layerVelocity, width, height;
}

@property float layerVelocity;

-(id)initWithWidth:(float)width height:(float)height pixelRatio:(float)pixelRatio numStars:(int)numStars starSize:(float)starSize velocity:(float)velocity;
+(UIImage *)starfieldImageWithStars:(int)num width:(int)width height:(int)height starSize:(float)starSize;

@end

@interface StarfieldLayerShape : TEPolygon

-(id)initWithWidth:(float)width height:(float)height textureImage:(UIImage *)image;

@end