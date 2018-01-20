//
//  LocalizationRating.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 26.12.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationRating : NSObject

+ (NSString *)title:(NSUInteger)count;
+ (NSString *)message;

+ (NSString *)now:(NSString *)name;
+ (NSString *)later;
+ (NSString *)never;

@end
