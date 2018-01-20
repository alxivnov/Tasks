//
//  LocalizationRepeat.h
//  Done!
//
//  Created by Alexander Ivanov on 15.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

@import Foundation;

@interface LocalizationRepeat : NSObject

+ (NSString *)repeat;
+ (NSString *)daily;
+ (NSString *)weekly;
+ (NSString *)monthly;
+ (NSString *)everyday;
+ (NSString *)day1;
+ (NSString *)days234;
+ (NSString *)days567890;
+ (NSString *)repeated;
+ (NSString *)skipRepetition;

+ (NSString *)message;

@end
