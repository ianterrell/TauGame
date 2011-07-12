//
//  TECharacterLoader.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECharacterLoader.h"
#import "TauEngine.h"

@implementation TECharacterLoader

+(void)parseTransformsForNode:(TEDrawable *)node attributes:(NSDictionary *)attributes {
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([key isEqualToString:@"scale"]) {
      node.scale = [obj floatValue];
    } else if ([key isEqualToString:@"translation"]) {
      node.translation = GLKVector2Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue]);
    } else if ([key isEqualToString:@"rotation"]) {
      node.rotation = [obj floatValue];
    } 
  }];
}

+(TEShape *)createShape:(NSDictionary *)attributes {
  NSString *geometry = [attributes objectForKey:@"geometry"];
  TEShape *shape;
  if ([geometry isEqualToString:@"triangle"]) {
    shape = [[TETriangle alloc] init];
  } else if ([geometry isEqualToString:@"square"] || [geometry isEqualToString:@"rectangle"]) {
    shape = [[TERectangle alloc] init];
  } else if ([geometry isEqualToString:@"circle"] || [geometry isEqualToString:@"ellipse"]) {
    shape = [[TEEllipse alloc] init];
  } else {
    NSLog(@"Unrecognized shape: '%@'", geometry);
    return nil;
  }
  
  [self parseTransformsForNode:shape attributes:attributes];

  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([key isEqualToString:@"color"]) {
      shape.color = GLKVector4Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue], 
                                   [[obj objectAtIndex:2] floatValue], [[obj objectAtIndex:3] floatValue]);
    } else if ([key isEqualToString:@"vertex0"]) {
      ((TETriangle *)shape).vertex0 = GLKVector2Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue]);
    } else if ([key isEqualToString:@"vertex1"]) {
      ((TETriangle *)shape).vertex1 = GLKVector2Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue]);
    } else if ([key isEqualToString:@"vertex2"]) {
      ((TETriangle *)shape).vertex2 = GLKVector2Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue]);
    } else if ([key isEqualToString:@"height"]) {
      ((TERectangle *)shape).height = [obj floatValue];
    } else if ([key isEqualToString:@"width"]) {
      ((TERectangle *)shape).width = [obj floatValue];
    } else if ([key isEqualToString:@"radius"]) {
      ((TEEllipse *)shape).radiusX = [obj floatValue];
      ((TEEllipse *)shape).radiusY = [obj floatValue];
    } else if ([key isEqualToString:@"radiusX"]) {
      ((TEEllipse *)shape).radiusX = [obj floatValue];
    } else if ([key isEqualToString:@"radiusY"]) {
      ((TEEllipse *)shape).radiusY = [obj floatValue];
    } 
  }];
  return shape;
}

+(void)parseNode:(TENode *)node attributes:(NSDictionary *)attributes {
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [self parseTransformsForNode:node attributes:attributes];
    if ([key isEqualToString:@"shape"]) {
      TEShape *shape = [self createShape:obj];
      node.shape = shape;
      shape.parent = node;
    } else if ([key isEqualToString:@"children"]) {
      [obj enumerateKeysAndObjectsUsingBlock:^(id childName, id childAttributes, BOOL *stop) {
        TENode *childNode = [[TENode alloc] init];
        childNode.name = childName;
        [self parseNode:childNode attributes:childAttributes];
        [node addChild:childNode];
      }];
    }
  }];
}

+(TECharacter *)loadCharacterFromJSONFile:(NSString *)fileName {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];

  NSError *error;
  NSDictionary *characterData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if (!characterData) {
    NSLog(@"Could not load character data, error is %@", error);
    return nil;
  }
  
  TECharacter *character = [[TECharacter alloc] init];
  character.name = [[characterData allKeys] objectAtIndex:0];
  [self parseNode:character attributes:[characterData objectForKey:character.name]];
  
  return character;
}
   
@end
