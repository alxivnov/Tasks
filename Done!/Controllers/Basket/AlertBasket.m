//
//  AlertBasket.m
//  Done!
//
//  Created by Alexander Ivanov on 15.12.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "AlertBasket.h"
#import "Action+Activity.h"
#import "AlertHelper.h"
#import "Basket+Activity.h"
#import "Basket+Alert.h"
#import "Basket+Tasks.h"
#import "Basket+Widget.h"
#import "Localization.h"
#import "WatchDelegate.h"
#import "Workflow.h"

#import "NSDate+Calculation.h"
#import "UIApplication+Notification.h"

@interface AlertBasket ()
@property (strong, nonatomic) NSDate *today;
@property (strong, nonatomic) NSDate *tomorrow;
@property (strong, nonatomic) NSDate *overdueDate;
@property (strong, nonatomic) NSDate *processDate;
@end

@implementation AlertBasket

- (NSDate *)today {
	return [AlertHelper today];
}

- (NSDate *)tomorrow {
	return [AlertHelper tomorrow];
}

- (NSDate *)overdueDate {
	return [AlertHelper overdueDate];
}

- (NSDate *)processDate {
	return [AlertHelper processDate];
}

- (void)updateWatch {
	NSArray *tasks = [[self.basket tasks:[self today]] saveToArray];
	NSDictionary *message = @{ EXT_LIST_KEY : tasks, EXT_STRING_KEY : [[Localization today] uppercaseString] };
	[[WatchDelegate instance].reachableSession sendMessage:message];
}

- (void)done:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSUInteger previousState = action.state;
	NSDate *previousDate = [action.date dateComponent];
	
	[super done:indexPath];
	
	if (self.basket.parent)
		return;
	
	if ([previousDate isEqualToDate:self.today]) {
		[self.basket scheduleWidgetForToday:NSNotFound];

		[self updateWatch];
	} else if ([previousDate isEqualToDate:self.tomorrow])
		[self.basket scheduleBadgeForTomorrow:NSNotFound];
	
	NSDate *overdueDay = [self.overdueDate dateComponent];
	if ([previousDate isLessThan:overdueDay])
		[self.basket scheduleOverdueAlert:NO];
	
	if (previousState == 0)
		[self.basket scheduleProcessAlert:NO];
	else if (previousState == GTD_ACTION_STATE_CALENDAR)
		[UIApplication cancelLocalNotificationWithIdentifier:action.uuid];
	
	[action deleteSearchableItem];
}

- (void)undone:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	[super undone:indexPath];
	
	if (self.basket.parent)
		return;
	
	NSUInteger state = action.state;
	NSDate *previousDate = [action.date dateComponent];
	
	if ([previousDate isEqualToDate:self.today]) {
		[self.basket scheduleWidgetForToday:NSNotFound];

		[self updateWatch];
	} else if ([previousDate isEqualToDate:self.tomorrow])
		[self.basket scheduleBadgeForTomorrow:NSNotFound];
	
	NSDate *overdueDay = [self.overdueDate dateComponent];
	if ([previousDate isLessThan:overdueDay])
		[self.basket scheduleOverdueAlert:NO];
	
	if (state == 0)
		[self.basket scheduleProcessAlert:NO];
	else if (state == GTD_ACTION_STATE_CALENDAR)
		[AlertHelper scheduleCalendarAlert:action calendarTime:self.settings.notificationCalendar.time];
	
	[action indexSearchableItem];
}

- (void)deferral:(NSIndexPath *)indexPath date:(NSDate *)date {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSUInteger previousState = action.state;
	NSDate *previousDate = [action.date dateComponent];
	
	[super deferral:indexPath date:date];
	
	if (self.basket.parent)
		return;
	
	if ([previousDate isEqualToDate:self.today] || [date isEqualToDate:self.today]) {
		[self.basket scheduleWidgetForToday:NSNotFound];

		[self updateWatch];
	}
	
	if ([previousDate isEqualToDate:self.tomorrow] || [date isEqualToDate:self.tomorrow])
		[self.basket scheduleBadgeForTomorrow:NSNotFound];
	
	NSDate *overdueDay = [self.overdueDate dateComponent];
	if ([previousDate isLessThan:overdueDay] || [date isLessThan:overdueDay])
		[self.basket scheduleOverdueAlert:NO];
	
	if (previousState == 0)
		[self.basket scheduleProcessAlert:NO];
	else if (previousState == GTD_ACTION_STATE_CALENDAR)
		[UIApplication cancelLocalNotificationWithIdentifier:action.uuid];
	
	[action indexSearchableItem];
}

- (void)calendar:(NSIndexPath *)indexPath date:(NSDate *)date repeat:(NSNumber *)repeat sound:(NSString *)sound alert:(NSNumber *)alert {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSUInteger previousState = action.state;
	NSDate *previousDate = [action.date dateComponent];
	
	[super calendar:indexPath date:date repeat:repeat sound:sound alert:alert];
	
	if (self.basket.parent)
		return;
	
	date = [date dateComponent];
	
	if ([previousDate isEqualToDate:self.today] || [date isEqualToDate:self.today]) {
		[self.basket scheduleWidgetForToday:NSNotFound];

		[self updateWatch];
	}
	
	if ([previousDate isEqualToDate:self.tomorrow] || [date isEqualToDate:self.tomorrow])
		[self.basket scheduleBadgeForTomorrow:NSNotFound];
	
	NSDate *overdueDay = [self.overdueDate dateComponent];
	if ([previousDate isLessThan:overdueDay] || [date isLessThan:overdueDay])
		[self.basket scheduleOverdueAlert:NO];
	
	if (previousState == 0)
		[self.basket scheduleProcessAlert:NO];
	
	[AlertHelper scheduleCalendarAlert:action calendarTime:self.settings.notificationCalendar.time];
	
	[action indexSearchableItem];
}

- (void)delegate:(NSIndexPath *)indexPath owner:(NSInteger)owner ownerDescription:(NSString *)ownerDescription {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSUInteger previousState = action.state;
	NSDate *previousDate = [action.date dateComponent];
	
	[super delegate:indexPath owner:owner ownerDescription:ownerDescription];
	
	if (self.basket.parent)
		return;
	
	if ([previousDate isEqualToDate:self.today]) {
		[self.basket scheduleWidgetForToday:NSNotFound];

		[self updateWatch];
	} else if ([previousDate isEqualToDate:self.tomorrow])
		[self.basket scheduleBadgeForTomorrow:NSNotFound];
	
	NSDate *overdueDay = [self.overdueDate dateComponent];
	if ([previousDate isLessThan:overdueDay])
		[self.basket scheduleOverdueAlert:NO];
	
	if (previousState == 0)
		[self.basket scheduleProcessAlert:NO];
	else if (previousState == GTD_ACTION_STATE_CALENDAR)
		[UIApplication cancelLocalNotificationWithIdentifier:action.uuid];
	
	[action deleteSearchableItem];
}

- (void)add:(NSIndexPath *)indexPath {
	[super add:indexPath];
	
	if (self.basket.parent)
		return;
	
	[self.basket scheduleProcessAlert:NO];
	
	[self.basket scheduleReviewAlert];
	
//	[action indexSearchableItem];
}

- (void)remove:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSUInteger previousState = action.state;
	NSDate *previousDate = [action.date dateComponent];
	
	[super remove:indexPath];
	
	if (self.basket.parent)
		return;
	
	if ([previousDate isEqualToDate:self.today]) {
		[self.basket scheduleWidgetForToday:NSNotFound];

		[self updateWatch];
	} else if ([previousDate isEqualToDate:self.tomorrow])
		[self.basket scheduleBadgeForTomorrow:NSNotFound];
	
	NSDate *overdueDay = [self.overdueDate dateComponent];
	if ([previousDate isLessThan:overdueDay])
		[self.basket scheduleOverdueAlert:NO];
	
	if (previousState == 0)
		[self.basket scheduleProcessAlert:NO];
	else if (previousState == GTD_ACTION_STATE_CALENDAR)
		[UIApplication cancelLocalNotificationWithIdentifier:action.uuid];
	
	[self.basket scheduleReviewAlert];
	
	[action deleteSearchableItem];
}

- (void)inBasket:(NSIndexPath *)indexPath {
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSUInteger previousState = action.state;
	NSDate *previousDate = [action.date dateComponent];
	
	[super inBasket:indexPath];
	
	if (self.basket.parent)
		return;
	
	if ([previousDate isEqualToDate:self.today]) {
		[self.basket scheduleWidgetForToday:NSNotFound];

		[self updateWatch];
	} else if ([previousDate isEqualToDate:self.tomorrow])
		[self.basket scheduleBadgeForTomorrow:NSNotFound];
	
	NSDate *overdueDay = [self.overdueDate dateComponent];
	if ([previousDate isLessThan:overdueDay])
		[self.basket scheduleOverdueAlert:NO];
	
	[self.basket scheduleProcessAlert:NO];
	
	if (previousState == GTD_ACTION_STATE_CALENDAR)
		[UIApplication cancelLocalNotificationWithIdentifier:action.uuid];
	
	[self.basket scheduleReviewAlert];
	
	[action deleteSearchableItem];
}

- (void)clear:(NSArray *)indexPaths {
	[super clear:indexPaths];
	
	if (self.basket.parent)
		return;
	
	[self.basket scheduleReviewAlert];
	
//	[action indexSearchableItem];
}

- (void)edit:(NSIndexPath *)indexPath title:(NSString *)title {
	[super edit:indexPath title:title];
	
	if (self.basket.parent)
		return;
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSUInteger state = action.state;
	NSDate *date = [action.date dateComponent];
	
	if ([date isEqualToDate:self.today]) {
//		[self.basket scheduleWidgetForToday:NO];

		[self updateWatch];
	}
//	else if ([date isEqualToDate:self.tomorrow])
//		[self.basket scheduleWidgetForTomorrow:NO];
	
	if (state == GTD_ACTION_STATE_CALENDAR)
		[AlertHelper scheduleCalendarAlert:action calendarTime:self.settings.notificationCalendar.time];
	
	[action indexSearchableItem];
}

- (void)order:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
	[super order:indexPath newIndexPath:newIndexPath];
	
	NSUInteger row = [self rowForIndexPath:indexPath];
	Action *action = [self.basket index:row];
	
	NSDate *date = [action.date dateComponent];
	
	if ([date isEqualToDate:self.today]) {
//		[self.basket scheduleWidgetForToday:NO];

		[self updateWatch];
	}
//	else if ([date isEqualToDate:self.tomorrow])
//		[self.basket scheduleWidgetForTomorrow:NO];
}

- (void)import:(Action *)action {
	[super import:action];
	
	if (self.basket.parent)
		return;
	
	[self.basket scheduleNotifications];
	[self.basket indexSearchableItems];
}

- (void)significantTimeChange {
	[AlertHelper significantTimeChange];
	
	[self.basket scheduleNotifications];
	[self.basket indexSearchableItems];
	
	[self reloadTableView:YES];
}

@end
