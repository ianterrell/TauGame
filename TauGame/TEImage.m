//
//  TEImage.m
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEImage.h"

@implementation TEImage

+(UIImage *)imageFromText:(NSString *)text
{
  UIFont *font = [UIFont systemFontOfSize:20.0];
  CGSize size  = [text sizeWithFont:font];
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef contextRef =  CGBitmapContextCreate (NULL,
                                                    size.width, size.height,
                                                    8, 4*size.width,
                                                    colorSpace,
                                                    kCGImageAlphaPremultipliedFirst
                                                    );
  CGColorSpaceRelease(colorSpace);
  UIGraphicsPushContext(contextRef);
  
  [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
  UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(contextRef) scale:1.0 orientation:UIImageOrientationDownMirrored];
  
  UIGraphicsPopContext();
  
  return image;
}

@end