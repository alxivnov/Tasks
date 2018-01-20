//
//  Basket+Alert.m
//  Done!
//
//  Created by Alexander Ivanov on 28.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Folder.h"
#import "AlertHelper.h"
#import "Basket+Alert.h"
#import "Basket+Query.h"
#import "Basket+Widget.h"
#import "LocalizationAlert.h"
#import "Workflow.h"

#import "NSDate+Calculation.h"
#import "UIApplication+Notification.h"

@implementation Basket (Alert)

- (void)scheduleNotifications {
//	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	[UIApplication cancelAllFutureLocalNotifications];
	
	[self scheduleWidgetForToday:NSNotFound];
	[self scheduleBadgeForTomorrow:NSNotFound];
	
	[self scheduleOverdueAlert:NO];
	
	[self scheduleProcessAlert:NO];
	
	[self scheduleReviewAlert];

	for (NSUInteger index = 0; index < [self count]; index++) {
		Action *action = [self index:index];
		if (action.state == GTD_ACTION_STATE_CALENDAR)
			[AlertHelper scheduleCalendarAlert:action calendarTime:GLOBAL.settings.notificationCalendar.time];
	};
}

- (void)scheduleBadgeForToday:(NSUInteger)count {
	if ([Workflow instance].settings.notificationBadge) {
		NSDate *today = [AlertHelper today];
//		[[NSCalendar currentCalendar] isDateInToday:(NSDate *)];
		if (count == NSNotFound)
			count = [self rangeWhereDateIsEqualTo:today].length;
		[UIApplication sharedApplication].applicationIconBadgeNumber = count;
	} else {
		[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	}
}

- (void)scheduleBadgeForTomorrow:(NSUInteger)count {
	if ([Workflow instance].settings.notificationBadge) {
		NSDate *tomorrow = [AlertHelper tomorrow];
//		[[NSCalendar currentCalendar] isDateInTomorrow:(NSDate *)];
		if (count == NSNotFound)
			count = [self rangeWhereDateIsEqualTo:tomorrow].length;
		[UIApplication scheduleLocalNotificationWithIdentifier:ALERT_BADGE fireDate:tomorrow applicationIconBadgeNumber:count];
	} else {
		[UIApplication cancelLocalNotificationWithIdentifier:ALERT_BADGE];
	}
}

- (void)scheduleOverdueAlert:(BOOL)updateDate {
	if (updateDate)
		[AlertHelper setOverdueDate:Nil];
	
	Workflow *workflow = [Workflow instance];
	
	if (!workflow.settings.notificationOverdue.on) {
		[UIApplication cancelLocalNotificationWithIdentifier:ALERT_OVERDUE];
		return;
	}
	
	BOOL today = [[AlertHelper overdueDate] isLessThan:[AlertHelper tomorrow]];
	NSUInteger count = [self rangeWhereDateIsLessThan:today ? [AlertHelper today] : [AlertHelper tomorrow]].length;
	if (count) {
		NSString *body = [NSString stringWithFormat:[LocalizationAlert bodyOverdue], @(count)];
		[UIApplication scheduleLocalNotificationWithIdentifier:ALERT_OVERDUE fireDate:[AlertHelper overdueDate] alertBody:body soundName:workflow.settings.notificationOverdue.sound category:Nil];
	} else {
		[UIApplication cancelLocalNotificationWithIdentifier:ALERT_OVERDUE];
	}
}

- (void)scheduleProcessAlert:(BOOL)updateDate {
	if (updateDate)
		[AlertHelper setProcessDate:Nil];
	
	Workflow *workflow = [Workflow instance];
	
	if (!workflow.settings.notificationProcess.on) {
		[UIApplication cancelLocalNotificationWithIdentifier:ALERT_PROCESS];
		return;
	}
	
	NSUInteger count = [self rangeWhereStateIsEqualToZero].length;
	if (count) {
		NSString *body = [NSString stringWithFormat:[LocalizationAlert bodyProcess], @(count)];
		[UIApplication scheduleLocalNotificationWithIdentifier:ALERT_PROCESS fireDate:[AlertHelper processDate] alertBody:body soundName:workflow.settings.notificationProcess.sound category:Nil];
	} else {
		[UIApplication cancelLocalNotificationWithIdentifier:ALERT_PROCESS];
	}
}

- (void)scheduleReviewAlert {
	Workflow *workflow = [Workflow instance];
	
	if (!workflow.settings.notificationReview.on) {
		[UIApplication cancelLocalNotificationWithIdentifier:ALERT_REVIEW];
		return;
	}
	
	NSUInteger count = [self count];
	if (count) {
		NSDate *friday1700 = [[NSDate date] nextWeekday:WEEKDAY_FRIDAY withTime:workflow.settings.notificationReview.time];
		NSString *body = [NSString stringWithFormat:[LocalizationAlert bodyReview], @(count)];
		[UIApplication scheduleLocalNotificationWithIdentifier:ALERT_REVIEW fireDate:friday1700 repeatInterval:NSWeekCalendarUnit alertBody:body alertAction:Nil soundName:workflow.settings.notificationReview.sound category:Nil];
	} else {
		[UIApplication cancelLocalNotificationWithIdentifier:ALERT_REVIEW];
	}
}

@end
