//
//  Localization.m
//  Done!
//
//  Created by Alexander Ivanov on 30.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Localization.h"

@implementation Localization

+ (NSString *)ok {
	return NSLocalizedString(@"OK", Nil);
}

+ (NSString *)done {
	return NSLocalizedString(@"DONE", Nil);
}

+ (NSString *)cancel {
	return NSLocalizedString(@"CANCEL", Nil);
}

+ (NSString *)later {
	return NSLocalizedString(@"Later", Nil);
}

+ (NSString *)newAction {
	return NSLocalizedString(@"NEW_ACTION", Nil);
}
	
+ (NSString *)deleteAction {
	return NSLocalizedString(@"DELETE_ACTION", Nil);
}

+ (NSString *)deleteFolder {
	return NSLocalizedString(@"Delete project", Nil);
}

+ (NSString *)moveToInBasket {
	return NSLocalizedString(@"Move to In-Basket", Nil);
}

+ (NSString *)undoAction {
	return NSLocalizedString(@"UNDO_ACTION", Nil);
}

+ (NSString *)date {
	return NSLocalizedString(@"Date", Nil);
}

+ (NSString *)time {
	return NSLocalizedString(@"Time", Nil);
}

+ (NSString *)alert {
	return NSLocalizedString(@"Alert", Nil);
}

+ (NSString *)atTheSameTime {
	return NSLocalizedString(@"At the same time", Nil);
}

+ (NSString *)before:(NSString *)someTime {
	return [NSString stringWithFormat:NSLocalizedString(@"%@ before", Nil), someTime];
}

+ (NSString *)postpone {
	return NSLocalizedString(@"Postpone", Nil);
}

+ (NSString *)schedule {
	return NSLocalizedString(@"Schedule", Nil);
}

+ (NSString *)yesterday {
	return NSLocalizedString(@"YESTERDAY", Nil);
}

+ (NSString *)today {
	return NSLocalizedString(@"TODAY", Nil);
}

+ (NSString *)tomorrow {
	return NSLocalizedString(@"TOMORROW", Nil);
}

+ (NSString *)lastWeek {
	return NSLocalizedString(@"LAST_WEEK", Nil);
}

+ (NSString *)thisWeek {
	return NSLocalizedString(@"THIS_WEEK", Nil);
}

+ (NSString *)nextWeek {
	return NSLocalizedString(@"NEXT_WEEK", Nil);
}

+ (NSString *)lastMonth {
	return NSLocalizedString(@"LAST_MONTH", Nil);
}

+ (NSString *)thisMonth {
	return NSLocalizedString(@"THIS_MONTH", Nil);
}

+ (NSString *)nextMonth {
	return NSLocalizedString(@"NEXT_MONTH", Nil);
}

+ (NSString *)lastYear {
	return NSLocalizedString(@"LAST_YEAR", Nil);
}

+ (NSString *)thisYear {
	return NSLocalizedString(@"THIS_YEAR", Nil);
}

+ (NSString *)nextYear {
	return NSLocalizedString(@"NEXT_YEAR", Nil);
}

+ (NSString *)someday {
	return NSLocalizedString(@"SOMEDAY_MAYBE", Nil);
}

+ (NSString *)deferralMessage {
	return NSLocalizedString(@"How soon do you plan to do this?", Nil);
}

+ (NSString *)calendar {
	return NSLocalizedString(@"CALENDAR", Nil);
}

+ (NSString *)description {
	return NSLocalizedString(@"DESCRIPTION", Nil);
}

+ (NSString *)disabled {
	return NSLocalizedString(@"DISABLED", Nil);
}

+ (NSString *)enabled {
	return NSLocalizedString(@"ENABLED", Nil);
}

+ (NSString *)sound {
	return NSLocalizedString(@"SOUND", Nil);
}

+ (NSString *)try {
	return NSLocalizedString(@"TRY", Nil);
}

+ (NSString *)restore {
	return NSLocalizedString(@"Restore", Nil);
}

+ (NSString *)emptyFocus {
	return NSLocalizedString(@"You don't have tasks for today.\n•\nGo back by pinching in or shaking.", Nil);
}

+ (NSString *)emptyFolder {
	return NSLocalizedString(@"You don't have tasks in this project.\n•\nAdd tasks by pulling down.\n•\nGo back by pinching in or shaking.", Nil);
}

+ (NSString *)inBasket {
	return NSLocalizedString(@"in-basket", Nil);
}

+ (NSString *)delegated {
	return NSLocalizedString(@"delegated", Nil);
}

+ (NSString *)completed {
	return NSLocalizedString(@"completed", Nil);
}

+ (NSString *)allDone {
	return NSLocalizedString(@"all done", Nil);
}

+ (NSString *)statisticsActionsInList {
	return NSLocalizedString(@"STATISTICS_ACTIONS_IN_LIST", Nil);
}

+ (NSString *)statisticsActionsForToday {
	return NSLocalizedString(@"STATISTICS_ACTIONS_FOR_TODAY", Nil);
}

+ (NSString *)statisticsActionsDoneTotal {
	return NSLocalizedString(@"STATISTICS_ACTIONS_DONE_TOTAL", Nil);
}

+ (NSString *)statisticsDaysPassedTotal {
	return NSLocalizedString(@"STATISTICS_DAYS_PASSED_TOTAL", Nil);
}

+ (NSString *)statisticsActionsDonePerDay {
	return NSLocalizedString(@"STATISTICS_ACTIONS_DONE_PER_DAY", Nil);
}

@end
