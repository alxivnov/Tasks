//
//  LocalizationHelp.m
//  Done!
//
//  Created by Alexander Ivanov on 15.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationHelp.h"

@implementation LocalizationHelp

+ (NSString *)help {
	return NSLocalizedString(@"Help", Nil);
}

+ (NSString *)application {
	return NSLocalizedString(@"Application", Nil);
}

+ (NSString *)folder {
	return NSLocalizedString(@"Projects", Nil);
}

+ (NSString *)repeat {
	return NSLocalizedString(@"Periodic tasks", Nil);
}

+ (NSString *)logger {
	return NSLocalizedString(@"Archive", Nil);
}

@end
