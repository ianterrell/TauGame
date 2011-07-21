//
//  TECharacterLoader.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECharacterLoader.h"
#import "TauEngine.h"
#import "Box2D.h"

@implementation TECharacterLoader

+(void)parseTransformsForNode:(TEDrawable *)node attributes:(NSDictionary *)attributes {
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([key isEqualToString:@"scale"]) {
      node.scale = [obj floatValue];
    } else if ([key isEqualToString:@"translation"]) {
      node.position = GLKVector2Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue]);
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

+(void)setUpColliders:(TENode *)node attributes:(NSDictionary *)attributes {
  NSString *collide = (NSString *)[attributes objectForKey:@"collide"];
  if ([collide isEqualToString:@"yes"]) {
    node.collide = YES;
    // TODO: Custom collision shapes, collisions on nodes w/o shapes
    if ([node.shape isKindOfClass:[TETriangle class]]) 
    {
      TETriangle *triangleShape = (TETriangle *)node.shape;
      b2PolygonShape *triangle = new b2PolygonShape();
      b2Vec2 vertices[3];
      vertices[0] = b2Vec2(triangleShape.vertex0.x, triangleShape.vertex0.y);
      vertices[1] = b2Vec2(triangleShape.vertex1.x, triangleShape.vertex1.y);
      vertices[2] = b2Vec2(triangleShape.vertex2.x, triangleShape.vertex2.y);
      triangle->Set(vertices, 3);
      node.collisionShape = (void *)triangle;
    } 
    else if ([node.shape isKindOfClass:[TEEllipse class]]) // Only works with circles!
    {
      
      TEEllipse *circleShape = (TEEllipse *)node.shape;
      b2CircleShape *circle = new b2CircleShape();
      circle->m_radius = circleShape.radiusX;
      node.collisionShape = (void *)circle;
    } 
    else if ([node.shape isKindOfClass:[TERectangle class]]) 
    {
      TERectangle *rectangleShape = (TERectangle *)node.shape;
      b2PolygonShape *box = new b2PolygonShape();
      box->SetAsBox(rectangleShape.width/2.0, rectangleShape.height/2.0);
      node.collisionShape = (void *)box;
    }
  }
}

+(void)loadCharacter:(TECharacter *)character fromJSONFile:(NSString *)fileName {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  
  NSError *error;
  NSDictionary *characterData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if (!characterData) {
    NSLog(@"Could not load character data, error is %@", error);
    return;
  }
  
  character.name = [[characterData allKeys] objectAtIndex:0];
  [self parseNode:character attributes:[characterData objectForKey:character.name]];
  [self setUpColliders:character attributes:[characterData objectForKey:character.name]];
}

+(TECharacter *)loadCharacterFromJSONFile:(NSString *)fileName {
  TECharacter *character = [[TECharacter alloc] init];
  [self loadCharacter:character fromJSONFile:fileName];
  return character;
}

   
@end
