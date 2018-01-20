//
//  Basket+Period.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 03.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Action+Period.h"
#import "Basket+Period.h"
#import "DateHelper.h"

@implementation Basket (Period)

- (NSRange)rangeWherePeriodIsEqualTo:(NSInteger)period {
	NSRange result = NSMakeRange(0, 0);
	NSUInteger count = [self count];
	for (NSInteger index = 0; index < count; index++) {
		Action *action = [self index:index];
		NSInteger actionPeriod = [action period];
		if (actionPeriod == period) {
			if (result.length == 0)
				result.location = index;
			result.length++;
		} else if (actionPeriod > period)
			break;
	}
	
	return result;
}

- (NSUInteger)indexWherePeriodIsCloseTo:(NSInteger)period {
	NSUInteger count = [self count];
	NSUInteger index = 0;
	for (; index < count; index++) {
		Action *action = [self index:index];
		NSInteger actionPeriod = [action period];
		if (actionPeriod == period)
			return index;
		else if (actionPeriod > period)
			break;
	}
	
	return period > DATE_TODAY
		? (index > 0 ? index - 1 : index < count ? index : NSNotFound)
		: (index < count ? index : index > 0 ? index - 1 : NSNotFound);
}

@end
