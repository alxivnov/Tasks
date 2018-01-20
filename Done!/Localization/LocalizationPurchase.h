//
//  LocalizationPurchase.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 06.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationPurchase : NSObject

+ (NSString *)purchase;
+ (NSString *)try;
+ (NSString *)expired;
+ (NSString *)title;
+ (NSString *)message;
+ (NSString *)disabled;
+ (NSString *)failed;
+ (NSString *)error;
+ (NSString *)restored;

@end
