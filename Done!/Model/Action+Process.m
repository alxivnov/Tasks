//
//  Action+Process.m
//  Done!
//
//  Created by Alexander Ivanov on 18.05.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Process.h"
#import "NSDate+Calculation.h"
#import "NSHelper.h"
#import "Workflow.h"

@implementation Action (Process)

- (void)process:(GTD_ACTION_STATE)state date:(NSDate *)date repeat:(NSNumber *)repeat sound:(NSString *)sound alert:(NSNumber *)alert owner:(NSInteger)owner ownerDescription:(NSString *)ownerDescription {
	GTD_ACTION_STATE previousState = self.state;
	
	self.state = state;
	
	if ((state == GTD_ACTION_STATE_NULL && previousState == GTD_ACTION_STATE_DONE) || state == GTD_ACTION_STATE_DONE)
		return;
	
	self.date = date;
	if (repeat)
		self.repeatInterval = [(NSNumber *)repeat boolValue] ? NSCalendarUnitMinute : 0;
	if (sound)
		self.soundName = sound;
	if (alert)
		self.alertInterval = alert.doubleValue;
	self.person = owner;
	self.personDescription = ownerDescription;
}

- (void)done {
	[self process:GTD_ACTION_STATE_DONE date:Nil repeat:@(NO) sound:STR_EMPTY alert:@(0.0) owner:0 ownerDescription:Nil];
}

- (void)deferral:(NSDate *)date {
	[self process:GTD_ACTION_STATE_DEFERRAL date:date repeat:@(NO) sound:STR_EMPTY alert:@(0.0) owner:0 ownerDescription:Nil];
}

- (void)calendar:(NSDate *)date repeat:(NSNumber *)repeat sound:(NSString *)sound alert:(NSNumber *)alert {
	[self process:GTD_ACTION_STATE_CALENDAR date:date repeat:repeat sound:sound alert:alert owner:0 ownerDescription:Nil];
}

- (void)delegate:(NSInteger)owner ownerDescription:(NSString *)ownerDescription {
	[self process:GTD_ACTION_STATE_DELEGATE date:[NSDate date] repeat:@(NO) sound:STR_EMPTY alert:@(0.0) owner:owner ownerDescription:ownerDescription];
}

- (void)undone {
	[self process:GTD_ACTION_STATE_NULL date:Nil repeat:@(NO) sound:STR_EMPTY alert:@(0.0) owner:0 ownerDescription:Nil];
}

- (NSDate *)dateForCalendarController {
	if (self.state == GTD_ACTION_STATE_CALENDAR)
		return self.date;

		NSDate *now = [NSDate date];
		NSDate *date = [[(self.state == GTD_ACTION_STATE_DEFERRAL && self.date ? self.date : now) dateComponent] move:[Workflow instance].settings.notificationCalendar.time];
		if ([date isGreaterThan:now])
			return date;
	
		NSUInteger interval = [now timeIntervalSinceReferenceDate];
		return [NSDate dateWithTimeIntervalSinceReferenceDate:interval + TIME_HOUR - interval % TIME_HOUR];
}

@end
