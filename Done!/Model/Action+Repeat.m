//
//  Action+Repeat.m
//  Done!
//
//  Created by Alexander Ivanov on 15.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Repeat.h"
#import "Action+Compare.h"
#import "Action+Description.h"
#import "Constants.h"
#import "DateHelper.h"
#import "LocalizationRepeat.h"

#import "NSArray+Query.h"
#import "NSDate+Calculation.h"
#import "SKInAppPurchase.h"

@implementation Action (Repeat)

- (NSDate *)repeatDate {
	NSUInteger firstNumber = [[self.repeatValues firstObject] unsignedIntegerValue];
	
	if (firstNumber < 40) {
		NSDate *date = Nil;
		
		for (NSNumber *value in self.repeatValues) {
			NSUInteger day = [value unsignedIntegerValue];
			
			NSDate *temp = Nil;
			if (self.state == GTD_ACTION_STATE_DEFERRAL && self.date)
				temp = firstNumber < 8
					? [self.date nextWeekday:day withTime:0]
					: [self.date nextDay:day - 7 withTime:0];
			else if (self.state == GTD_ACTION_STATE_CALENDAR && self.date)
				temp = firstNumber < 8
					? [self.date nextWeekday:day withTime:[self.date timeComponent]]
					: [self.date nextDay:day - 7 withTime:[self.date timeComponent]];
			else
				temp = firstNumber < 8
					? [[[NSDate date] dateComponent] nextWeekday:day withTime:0 square:self.state == 0]
					: [[[NSDate date] dateComponent] nextDay:day - 7 withTime:0 square:self.state == 0];
			
			if (date == Nil || [date isGreaterThan:temp])
				date = temp;
		}
		
		return date;
	} else {
		NSDate *date = self.state & (GTD_ACTION_STATE_DEFERRAL | GTD_ACTION_STATE_CALENDAR) && self.date
			? self.date
			: [[NSDate date] dateComponent];
//		[[NSCalendar currentCalendar] nextDateAfterDate:(NSDate *) matchingComponents:(NSDateComponents *) options:(NSCalendarOptions)];
		return [date addValue:firstNumber - 40 forComponent:NSCalendarUnitDay];
	}
}

- (NSString *)repeatDescription {
	NSUInteger firstNumber = [[self.repeatValues firstObject] unsignedIntegerValue];
	
	if (firstNumber < 8) {
		NSArray *days = [NSCalendar currentCalendar].shortWeekdaySymbols;
		NSUInteger count = [days count];
		
		if ([self.repeatValues count] == count)
			return [LocalizationRepeat everyday];
		
		NSInteger day = [self.date weekday];
		
		return [self.repeatValues componentsJoinedByString:@", " block:^NSString *(id item) {
			NSUInteger index = [item unsignedIntegerValue];
			if (index >= count)
				return Nil;
			
			NSString *weekdaySymbol = days[index];
			return index == day ? [weekdaySymbol uppercaseString] : weekdaySymbol;
		}];
	} else if (firstNumber < 40) {
		NSUInteger count = 31;
		
		if ([self.repeatValues count] == count)
			return [LocalizationRepeat everyday];
		
		return [self.repeatValues componentsJoinedByString:@", " block:^NSString *(id item) {
			NSUInteger index = [item unsignedIntegerValue] - 7;
			if (index > count)
				return Nil;
			
			return [@(index) description];
		}];
	} else if (firstNumber == 41) {
		return [LocalizationRepeat everyday];
	} else {
		return [DateHelper dayCountDescription:firstNumber - 40];
	}
}

- (NSString *)repeatDateDescription {
	NSString *description = [self dateDescription];
	if (!description)
		return Nil;
	
	if (!(self.repeat/* && [SKInAppPurchase purchaseByIdentifier:[Constants inAppPurchaseRepeat]].purchased*/))
		return description;
	
	return [NSString stringWithFormat:@"%@ (%@)", description, [self repeatDescription]];
}

@end
