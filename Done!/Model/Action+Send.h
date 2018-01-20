//
//  Action+Send.h
//  Done!
//
//  Created by Alexander Ivanov on 05.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action.h"

@interface Action (Send)

+ (Action *)importFromFile:(NSURL *)url;
- (NSURL *)exportToFile;

+ (Action *)importFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)exportToDictionary;

@end
