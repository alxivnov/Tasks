//
//  LocalizationSettings.m
//  Done!
//
//  Created by Alexander Ivanov on 29.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationSettings.h"

@implementation LocalizationSettings

+ (NSString *)version {
	return NSLocalizedString(@"Version", Nil);
}

+ (NSString *)feedback {
	return NSLocalizedString(@"Feedback", Nil);
}

+ (NSString *)sounds {
	return NSLocalizedString(@"Sounds", Nil);
}

+ (NSString *)theme {
	return NSLocalizedString(@"Theme", Nil);
}

+ (NSString *)theme:(NSUInteger)theme {
	return NSLocalizedString(theme == 1 ? @"Dark" : theme == 2 ? @"Light" : @"Automatic", Nil);
}

+ (NSString *)multilineTitles {
	return NSLocalizedString(@"Multiline titles", Nil);
}

+ (NSString *)deleteConfirmation {
	return NSLocalizedString(@"Delete confirmation", Nil);
}

+ (NSString *)iconBadge {
	return NSLocalizedString(@"Icon badge", Nil);
}

+ (NSString *)calendarReminder {
	return NSLocalizedString(@"Calendar reminder", Nil);
}

+ (NSString *)overdueReminder {
	return NSLocalizedString(@"Overdue reminder", Nil);
}

+ (NSString *)processReminder {
	return NSLocalizedString(@"Process reminder", Nil);
}

+ (NSString *)reviewReminder {
	return NSLocalizedString(@"Review reminder", Nil);
}

+ (NSString *)postpone {
	return NSLocalizedString(@"Postpone", Nil);
}

+ (NSString *)restorePurchases {
	return NSLocalizedString(@"Restore in-app purchases", Nil);
}

+ (NSString *)sendStatistics {
	return NSLocalizedString(@"Send usage statistics", Nil);
}

+ (NSString *)migrationTitle {
	return NSLocalizedString(@"Change in storage", Nil);
}

+ (NSString *)migrationMessage {
	return NSLocalizedString(@"Сopy existing tasks to the new storage?", Nil);
}

@end
