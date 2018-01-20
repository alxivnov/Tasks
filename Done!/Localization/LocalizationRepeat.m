//
//  LocalizationRepeat.m
//  Done!
//
//  Created by Alexander Ivanov on 15.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationRepeat.h"

@implementation LocalizationRepeat

+ (NSString *)repeat {
	return NSLocalizedString(@"Repeat", Nil);
}

+ (NSString *)daily {
	return NSLocalizedString(@"DAY", Nil);
}

+ (NSString *)weekly {
	return NSLocalizedString(@"WEEK", Nil);
}

+ (NSString *)monthly {
	return NSLocalizedString(@"MONTH", Nil);
}

+ (NSString *)everyday {
	return NSLocalizedString(@"everyday", Nil);
}

+ (NSString *)repeated {
	return NSLocalizedString(@"done %@ times", Nil);
}

+ (NSString *)skipRepetition {
	return NSLocalizedString(@"Skip repetition", Nil);
}

+ (NSString *)day1 {
	return NSLocalizedString(@"REPEAT_DAY_1", Nil);
}

+ (NSString *)days234 {
	return NSLocalizedString(@"REPEAT_DAY_234", Nil);
}

+ (NSString *)days567890 {
	return NSLocalizedString(@"REPEAT_DAY_567890", Nil);
}

+ (NSString *)message {
	return NSLocalizedString(@"Enable repeat and notification will be coming every minute until you act on it.", Nil);
}

@end
