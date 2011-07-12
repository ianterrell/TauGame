//
//  TECharacterLoader.h
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECharacter.h"

@interface TECharacterLoader : NSObject

+(TECharacter *)loadCharacterFromJSONFile:(NSString *)fileName;

@end
