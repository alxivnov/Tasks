//
//  Action+Compare.m
//  Done!
//
//  Created by Alexander Ivanov on 04.12.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "Action+Compare.h"
#import "NSHelper.h"
#import "NSDate+Calculation.h"

@implementation Action (Compare)

- (NSComparisonResult)compareByTtile:(Action *)action {
    return [self.title compare:action.title];
}

- (NSComparisonResult)compareByStateTo:(Action *)action {
	return self.state > action.state ? NSOrderedDescending : self.state < action.state ? NSOrderedAscending : NSOrderedSame;
}

- (NSComparisonResult)compareByStateWith:(Action *)action {
	return ((self.state & (GTD_ACTION_STATE_DEFERRAL | GTD_ACTION_STATE_CALENDAR)) && (action.state & (GTD_ACTION_STATE_DEFERRAL | GTD_ACTION_STATE_CALENDAR))) ? NSOrderedSame : [self compareByStateTo:action];
}

- (NSComparisonResult)compareByOwner:(Action *)action {
    return [NSHelper string:self.personDescription compare:action.personDescription];
}

- (NSComparisonResult)compareByDate:(Action *)action {
	NSTimeInterval selfInterval = [self.date timeIntervalSinceReferenceDate];
	NSTimeInterval actionInterval = [action.date timeIntervalSinceReferenceDate];

	if ((self.state & GTD_ACTION_STATE_CALENDAR) && !(action.state & GTD_ACTION_STATE_CALENDAR))
		selfInterval -= [self.date timeComponent];
	if ((action.state & GTD_ACTION_STATE_CALENDAR) && !(self.state & GTD_ACTION_STATE_CALENDAR))
		actionInterval -= [action.date timeComponent];

    return selfInterval == actionInterval ? NSOrderedSame : selfInterval == 0 ? NSOrderedDescending : actionInterval == 0 ? NSOrderedAscending : selfInterval > actionInterval ? NSOrderedDescending : NSOrderedAscending;
}

// sort
- (NSComparisonResult)compare:(Action *)action {
	NSComparisonResult order = [self compareByStateWith:action];
	if (order != NSOrderedSame)
		return order;
	
	switch (self.state) {
		case GTD_ACTION_STATE_DONE:
			return [NSHelper date:self.deleted compare:action.deleted];
//			return [self compareByDate:action];
		case GTD_ACTION_STATE_DEFERRAL:
		case GTD_ACTION_STATE_CALENDAR: {
			NSComparisonResult result = [self compareByDate:action];
			return result != NSOrderedSame ? result : [self compareByStateTo:action];
		}
		case GTD_ACTION_STATE_DELEGATE:
			return [self compareByOwner:action];
		default:
			return [NSHelper date:self.created compare:action.created];
	}
}

// order
- (NSComparisonResult)compareByKind:(Action *)action {
	NSComparisonResult order = [self compareByStateWith:action];
	if (order != NSOrderedSame)
		return order;
	
	switch (self.state) {
		case GTD_ACTION_STATE_DEFERRAL:
		case GTD_ACTION_STATE_CALENDAR: {
			NSComparisonResult result = [self compareByStateTo:action];
			return result != NSOrderedSame ? result : [self compareByDate:action];
		}
		case GTD_ACTION_STATE_DELEGATE:
			return [self compareByOwner:action];
		default:
			return order;
	}
}

// group
- (NSComparisonResult)periodize {
//	[[NSCalendar currentCalendar] compareDate:(NSDate *) toDate:(NSDate *) toUnitGranularity:(NSCalendarUnit)];
	switch (self.state) {
		case GTD_ACTION_STATE_DEFERRAL:
			return [NSHelper date:[self.date dateComponent] compare:[[NSDate date] dateComponent]];
		case GTD_ACTION_STATE_CALENDAR: {
			NSComparisonResult period = [NSHelper date:[self.date dateComponent] compare:[[NSDate date] dateComponent]];
			
			if  (period == NSOrderedSame && [[self.date component:NSMinuteCalendarUnit] isLessThanOrEqual:[[NSDate date] component:NSMinuteCalendarUnit]])
				period = NSOrderedAscending;
			
			return period;
		}
		case GTD_ACTION_STATE_DELEGATE:
			return NSOrderedDescending;
		case GTD_ACTION_STATE_DONE:
			return NSOrderedDescending;
		default:
			return NSOrderedAscending;
	}
}

@end
