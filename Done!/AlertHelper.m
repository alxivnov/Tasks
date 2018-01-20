//
//  AlertHelper.m
//  Done!
//
//  Created by Alexander Ivanov on 25.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Folder.h"
#import "AlertHelper.h"
#import "NotificationHelper.h"
#import "Workflow.h"

#import "NSBundle+Convenience.h"
#import "NSDate+Calculation.h"
#import "UIApplication+Notification.h"

@implementation AlertHelper

static NSDate* _today;
static NSDate* _tomorrow;
static NSDate* _overdueDate;
static NSDate* _processDate;

+ (NSDate *)today {
	NSDate *date = [NSDate date];
	
	if (!_today || !_tomorrow || [date isLessThan:_today] || [date isGreaterThanOrEqual:_tomorrow]) {
		_today = [date dateComponent];
		_tomorrow = [_today addValue:1 forComponent:NSCalendarUnitDay];
		_overdueDate = Nil;
		_processDate = Nil;
	}
	
	return _today;
}

+ (NSDate *)tomorrow {
	NSDate *today = [self today];
	
	if (!_tomorrow)
		_tomorrow = [today addValue:1 forComponent:NSCalendarUnitDay];
	
	return _tomorrow;
}

+ (NSDate *)overdueDate {
	NSDate *today = [self today];
	
	if (!_overdueDate)
		_overdueDate = [today move:[Workflow instance].settings.notificationOverdue.time];
	
	if ([_overdueDate isLessThanOrEqual:[NSDate date]])
		_overdueDate = [_overdueDate addValue:1 forComponent:NSCalendarUnitDay];
	
	return _overdueDate;
}

+ (NSDate *)processDate {
	NSDate *today = [self today];
	
	if (!_processDate)
		_processDate = [today move:[Workflow instance].settings.notificationProcess.time];
	
	if ([_processDate isLessThanOrEqual:[NSDate date]])
		_processDate = [_processDate addValue:1 forComponent:NSCalendarUnitDay];
	
	return _processDate;
}

+ (void)setOverdueDate:(NSDate *)date {
	_overdueDate = date;
}

+ (void)setProcessDate:(NSDate *)date {
	_processDate = date;
}

+ (void)significantTimeChange {
	_today = Nil;
}

+ (void)scheduleCalendarAlert:(Action *)action calendarTime:(NSTimeInterval)calendarTime {
	NSString *category = GUI_NOTIFICATION_CATEGORY_CALENDAR;
	
	NSDate *calendarDate = action.date;
	if (action.alertInterval >= TIME_SECOND) {
		calendarDate = [calendarDate dateByAddingTimeInterval:-action.alertInterval];
		if (action.alertInterval >= TIME_DAY)
			calendarDate = [[calendarDate dateComponent] dateByAddingTimeInterval:calendarTime];
		
		category = Nil;
	}
	
	if ([calendarDate isGreaterThan:[NSDate date]])
		[UIApplication scheduleLocalNotificationWithIdentifier:action.uuid fireDate:calendarDate repeatInterval:action.repeatInterval alertBody:[action folderDescription] alertAction:Nil soundName:[NSBundle resourceExists:action.soundName] ? action.soundName : [Workflow instance].settings.notificationCalendar.sound category:category];
	else
		[UIApplication cancelLocalNotificationWithIdentifier:action.uuid];
}

+ (void)didReceiveLocalNotificationWithUUID:(NSString *)uuid {
	if (!uuid || [uuid isEqualToString:ALERT_BADGE])
		return;

	if (![uuid isEqualToString:ALERT_OVERDUE] && ![uuid isEqualToString:ALERT_PROCESS] && ![uuid isEqualToString:ALERT_REVIEW])
		[UIApplication cancelLocalNotificationWithIdentifier:uuid];
}

@end
