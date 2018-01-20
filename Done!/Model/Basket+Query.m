//
//  Basket+Notification.m
//  Done!
//
//  Created by Alexander Ivanov on 14.12.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Basket+Query.h"
#import "NSDate+Calculation.h"

@implementation Basket (Query)

- (NSRange)rangeWhereDateIsEqualTo:(NSDate *)date {
	NSRange result = NSMakeRange(0, 0);
	NSUInteger count = [self count];
	for (NSInteger index = 0; index < count; index++) {
		Action *action = [self index:index];
		if (!action.date)
			continue;
		NSDate *actionDate = action.state == GTD_ACTION_STATE_CALENDAR ? [action.date dateComponent] : action.date;
		if ([actionDate isEqualToDate:date]) {
			if (result.length == 0)
				result.location = index;
			result.length++;
		} else if ([actionDate isGreaterThan:date])
			break;
	}
	
	return result;
}

- (NSRange)rangeWhereDateIsLessThan:(NSDate *)date {
	NSRange result = NSMakeRange(0, 0);
	NSUInteger count = [self count];
	for (NSInteger index = 0; index < count; index++) {
		Action *action = [self index:index];
		if (!action.date)
			continue;
		NSDate *actionDate = action.state == GTD_ACTION_STATE_CALENDAR ? [action.date dateComponent] : action.date;
		if ([actionDate isLessThan:date]) {
			if (result.length == 0)
				result.location = index;
			result.length++;
		} else if ([actionDate isGreaterThanOrEqual:date])
			break;
	}
	
	return result;
}

- (NSRange)rangeWhereDateIsGreaterThan:(NSDate *)date {
	NSRange result = NSMakeRange(0, 0);
	NSUInteger count = [self count];
	for (NSInteger index = count - 1; index >= 0; index--) {
		Action *action = [self index:index];
		if (!action.date)
			continue;
		NSDate *actionDate = action.state == GTD_ACTION_STATE_CALENDAR ? [action.date dateComponent] : action.date;
		if ([actionDate isGreaterThan:date]) {
			result.location = index;
			result.length++;
		} else if ([actionDate isLessThanOrEqual:date])
			break;
	}
	
	return result;
}

- (NSRange)rangeWhereStateIsEqualToZero {
	NSRange result = NSMakeRange(0, 0);
	NSUInteger count = [self count];
	for (NSInteger index = 0; index < count; index++) {
		Action *action = [self index:index];
		if (action.state == 0)
			result.length++;
		else
			break;
	}
	
	return result;
}

- (NSUInteger)indexWhereUuidIsEqualTo:(NSString *)uuid {
	NSUInteger count = [self count];
	for (NSUInteger index = 0; index < count; index++) {
		Action *action = [self index:index];
		if ([action.uuid isEqualToString:uuid])
			return index;
	}
	
	return NSNotFound;
}

- (NSArray *)indexesWhereStateIsEqualToDone {
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	
	for (NSInteger index = [self count] - 1; index >= 0; index--) {
		Action *action = [self index:index];
		if (action.state == GTD_ACTION_STATE_DONE)
			[indexPaths addObject:@(index)];
		else
			break;
	}
	
	return indexPaths;
}

@end
