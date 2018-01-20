//
//  Deferred.m
//  Done!
//
//  Created by Alexander Ivanov on 13.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "DateHelper.h"
#import "Localization.h"
#import "LocalizationRepeat.h"
#import "NSDate+Calculation.h"
#import "UIHelper.h"

@implementation DateHelper

+ (NSString *)dayCountDescription:(NSUInteger)count {
	if (IOS_8_0) {
		NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
		formatter.allowedUnits = NSCalendarUnitDay;
		formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
		return [formatter stringFromTimeInterval:count * TIME_DAY];
	}
	
	NSUInteger i0 = count % 10;
	NSUInteger i1 = (count % 100 - i0) / 10;
	
	return [NSString stringWithFormat:@"%@ %@", @(count),
		i0 == 1 && i1 != 1
			? [LocalizationRepeat day1]
			: i0 > 0 && i0 < 5 && i1 != 1
				? [LocalizationRepeat days234]
				: [LocalizationRepeat days567890]];
}

+ (NSInteger)dateIdentifier:(NSDate *)date {
	NSInteger identifier = [DateHelper dayIdentifier:date];
	if (identifier == 0)
		identifier = [DateHelper weekIdentifier:date];
	if (identifier == 0)
		identifier = [DateHelper monthIdentifier:date];
	if (identifier == 0)
		identifier = [DateHelper yearIdentifier:date];
	
	return identifier;
}

+ (NSString *)dayIdentifierDescription:(NSInteger)identifier {
	return identifier == DATE_TODAY ? [Localization today]
	: identifier == DATE_TOMOROW ? [Localization tomorrow]
	: identifier == DATE_YESTERDAY ? [Localization yesterday]
	: Nil;
}

+ (NSString *)weekIdentifierDescription:(NSInteger)identifier {
	return identifier == DATE_THIS_WEEK ? [Localization thisWeek]
	: identifier == DATE_NEXT_WEEK ? [Localization nextWeek]
	: identifier == DATE_LAST_WEEK ? [Localization lastWeek]
	: Nil;
}

+ (NSString *)monthIdentifierDescription:(NSInteger)identifier {
	return identifier == DATE_THIS_MONTH ? [Localization thisMonth]
	: identifier == DATE_NEXT_MONTH ? [Localization nextMonth]
	: identifier == DATE_LAST_MONTH ? [Localization lastMonth]
	: Nil;
}

+ (NSString *)yearIdentifierDescription:(NSInteger)identifier {
	return identifier == DATE_THIS_YEAR ? [Localization thisYear]
	: identifier == DATE_NEXT_YEAR ? [Localization nextYear]
	: identifier == DATE_LAST_YEAR ? [Localization lastYear]
	: Nil;
}

+ (NSString *)dateIdentifierDescription:(NSInteger)identifier {
	NSString *description = [self dayIdentifierDescription:identifier];
	if (!description)
		description = [self weekIdentifierDescription:identifier];
	if (!description)
		description = [self monthIdentifierDescription:identifier];
	if (!description)
		description = [self yearIdentifierDescription:identifier];
	if (!description)
		description = [Localization someday];
	return description;
}

+ (NSString *)dayDescription:(NSDate *)date {
	return [self dayIdentifierDescription:[self dayIdentifier:date]];
}

+ (NSString *)weekDescription:(NSDate *)date {
	return [self weekIdentifierDescription:[self weekIdentifier:date]];
}

+ (NSString *)monthDescription:(NSDate *)date {
	return [self monthIdentifierDescription:[self monthIdentifier:date]];
}

+ (NSString *)yearDescription:(NSDate *)date {
	return [self yearIdentifierDescription:[self yearIdentifier:date]];
}

+ (NSString *)dateDescription:(NSDate *)date {
	return [self dateIdentifierDescription:[self dateIdentifier:date]];
}

+ (NSInteger)dayIdentifier:(NSDate *)date {
	if (!date)
		return 0;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDate *nowDate = [NSDate date];
	NSTimeInterval nowTime = [nowDate timeIntervalSinceReferenceDate];
	
	NSDate *tempDate;
	NSTimeInterval tempTime;
	NSTimeInterval temp;
	
	[calendar rangeOfUnit:NSCalendarUnitDay startDate:&tempDate interval:&tempTime forDate:date];
	temp = [tempDate timeIntervalSinceReferenceDate];
	if (nowTime >= temp && nowTime - tempTime < temp)
		return DATE_TODAY;
	if (nowTime + tempTime >= temp && nowTime < temp)
		return DATE_TOMOROW;
	if (nowTime - tempTime >= temp && nowTime - 2 * tempTime < temp)
		return DATE_YESTERDAY;
	
	return 0;
}

+ (NSInteger)weekIdentifier:(NSDate *)date {
	if (!date)
		return 0;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDate *nowDate = [NSDate date];
	NSTimeInterval nowTime = [nowDate timeIntervalSinceReferenceDate];
	
	NSDate *tempDate;
	NSTimeInterval tempTime;
	NSTimeInterval temp;
	
//	[[NSCalendar currentCalendar] compareDate:(NSDate *) toDate:(NSDate *) toUnitGranularity:(NSCalendarUnit)];
	[calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&tempDate interval:&tempTime forDate:date];
	temp = [tempDate timeIntervalSinceReferenceDate];
	if (nowTime >= temp && nowTime - tempTime < temp)
		return DATE_THIS_WEEK;
	if (nowTime + tempTime >= temp && nowTime < temp)
		return DATE_NEXT_WEEK;
	if (nowTime - tempTime >= temp && nowTime - 2 * tempTime < temp)
		return DATE_LAST_WEEK;
	
	return 0;
}

+ (NSInteger)monthIdentifier:(NSDate *)date {
	if (!date)
		return 0;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDate *nowDate = [NSDate date];
	NSTimeInterval nowTime = [nowDate timeIntervalSinceReferenceDate];
	
	NSDate *tempDate;
	NSTimeInterval tempTime;
	NSTimeInterval temp1;
	NSTimeInterval temp2;
	
//	[[NSCalendar currentCalendar] compareDate:(NSDate *) toDate:(NSDate *) toUnitGranularity:(NSCalendarUnit)];
	[calendar rangeOfUnit:NSCalendarUnitMonth startDate:&tempDate interval:&tempTime forDate:date];
	temp1 = [tempDate timeIntervalSinceReferenceDate];
	temp2 = temp1 + tempTime;
	if (nowTime >= temp1 && nowTime < temp2)
		return DATE_THIS_MONTH;
	
	[calendar rangeOfUnit:NSCalendarUnitMonth startDate:&tempDate interval:&tempTime forDate:[NSDate dateWithTimeIntervalSinceReferenceDate:temp1 - 86400]];
	temp1 = [tempDate timeIntervalSinceReferenceDate];
	if (nowTime >= temp1 && nowTime < temp1 + tempTime)
		return DATE_NEXT_MONTH;
	
	[calendar rangeOfUnit:NSCalendarUnitMonth startDate:&tempDate interval:&tempTime forDate:[NSDate dateWithTimeIntervalSinceReferenceDate:temp2]];
	temp1 = [tempDate timeIntervalSinceReferenceDate];
	if (nowTime >= temp1 && nowTime < temp1 + tempTime)
		return DATE_LAST_MONTH;
	
	return 0;
}

+ (NSInteger)yearIdentifier:(NSDate *)date {
	if (!date)
		return 0;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDate *nowDate = [NSDate date];
	NSTimeInterval nowTime = [nowDate timeIntervalSinceReferenceDate];
	
	NSDate *tempDate;
	NSTimeInterval tempTime;
	NSTimeInterval temp1;
	NSTimeInterval temp2;
	
//	[[NSCalendar currentCalendar] compareDate:(NSDate *) toDate:(NSDate *) toUnitGranularity:(NSCalendarUnit)];
	[calendar rangeOfUnit:NSCalendarUnitYear startDate:&tempDate interval:&tempTime forDate:date];
	temp1 = [tempDate timeIntervalSinceReferenceDate];
	temp2 = temp1 + tempTime;
	if (nowTime >= temp1 && nowTime < temp2)
		return DATE_THIS_YEAR;
	
	[calendar rangeOfUnit:NSCalendarUnitYear startDate:&tempDate interval:&tempTime forDate:[NSDate dateWithTimeIntervalSinceReferenceDate:temp1 - 86400]];
	temp1 = [tempDate timeIntervalSinceReferenceDate];
	if (nowTime >= temp1 && nowTime < temp1 + tempTime)
		return DATE_NEXT_YEAR;
	
	[calendar rangeOfUnit:NSCalendarUnitYear startDate:&tempDate interval:&tempTime forDate:[NSDate dateWithTimeIntervalSinceReferenceDate:temp2]];
	temp1 = [tempDate timeIntervalSinceReferenceDate];
	if (nowTime >= temp1 && nowTime < temp1 + tempTime)
		return DATE_LAST_YEAR;
	
	return 0;
}

+ (NSArray *)deferralDates:(NSDate *)date {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDate *tempDate;
	NSTimeInterval tempTime;
	
//	[[NSCalendar currentCalendar] compareDate:(NSDate *) toDate:(NSDate *) toUnitGranularity:(NSCalendarUnit)];
	[calendar rangeOfUnit:NSCalendarUnitDay startDate:&tempDate interval:&tempTime forDate:date];
	[array addObject:tempDate];
	
	NSDate *tomorrow = [tempDate addValue:1 forComponent:NSCalendarUnitDay];
	[array addObject:tomorrow];
	
	[calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&tempDate interval:&tempTime forDate:date];
	NSDate *week = [[tempDate addValue:1 forComponent:NSCalendarUnitWeekOfMonth] addValue:-1 forComponent:NSCalendarUnitDay];
	if ([week isLessThanOrEqual:tomorrow])
		week = [week addValue:1 forComponent:NSCalendarUnitWeekOfMonth];
	[array addObject:week];
	
	
	[calendar rangeOfUnit:NSCalendarUnitMonth startDate:&tempDate interval:&tempTime forDate:date];
	NSDate *month = [[tempDate addValue:1 forComponent:NSCalendarUnitMonth] addValue:-1 forComponent:NSCalendarUnitDay];
	if ([month isLessThanOrEqual:week])
		month = [month addValue:1 forComponent:NSCalendarUnitMonth];
	[array addObject:month];
	
	
	[calendar rangeOfUnit:NSCalendarUnitYear startDate:&tempDate interval:&tempTime forDate:date];
	NSDate *year = [[tempDate addValue:1 forComponent:NSCalendarUnitYear] addValue:-1 forComponent:NSCalendarUnitDay];
	if ([year isLessThanOrEqual:month])
		year = [year addValue:1 forComponent:NSCalendarUnitYear];
	[array addObject:year];
	
	return array;
}

static NSArray *_deferralDates;

+ (NSArray *)deferralDates {
	NSDate *now = [NSDate date];
	
	if (!_deferralDates || ![[now dateComponent] isEqualToDate:[_deferralDates firstObject]]) {
		NSMutableArray *array = [NSMutableArray array];
		
		NSArray *dates = [[self class] deferralDates:now];
		NSUInteger count = [dates count];
		for (int index = 0; index < count; index++) {
			NSDate *date = dates[index];
			
			[array addObject:date];
			
			if (index == 2)
				[array addObject:[[self class] weekDescription:date]];
			else if (index == 3)
				[array addObject:[[self class] monthDescription:date]];
			else if (index == 4)
				[array addObject:[[self class] yearDescription:date]];
			else
				[array addObject:[[self class] dateDescription:date]];
		}
		
		_deferralDates = array;
	}
	
	return _deferralDates;
}

@end
