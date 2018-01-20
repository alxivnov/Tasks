//
//  LocalizationTour.m
//  AirTasks
//
//  Created by Alexander Ivanov on 25.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationTour.h"

@implementation LocalizationTour

+ (NSString *)welcome1 {
	return NSLocalizedString(@"WELCOME", Nil);
}

+ (NSString *)welcome2 {
	return NSLocalizedString(@"keep tasks here", Nil);
}

+ (NSString *)top {
	return NSLocalizedString(@"Pull down and release\nto add a new task.", Nil);
}

+ (NSString *)left {
	return NSLocalizedString(@"Pull a task to the right to\n• complete,\n• defer,\n• calendar or,\n• delegate it.", Nil);
}

+ (NSString *)right {
	return NSLocalizedString(@"Pull a task to the left to\n• remove,\n• repeat,\n• itemize or,\n• send it.", Nil);
}

+ (NSString *)bottom {
	return NSLocalizedString(@"Pull up and release\nto clear completed tasks.", Nil);
}

@end
