//
//  Settings.m
//  Done!
//
//  Created by Alexander Ivanov on 06.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Settings.h"
#import "Sounds.h"

#import "NSDictionary+Get.h"
#import "NSFileManager+Convenience.h"
#import "NSHelper.h"
#import "NSMutableDictionary+Set.h"
#import "NSURL+File.h"
#import "UIHelper.h"

#define KEY_ICLOUD @"iCloud"

#define KEY_SOUNDS @"sounds"

#define KEY_MULTILINE_TITLES @"multilineTitles"

#define KEY_THEME @"theme"

#define KEY_DELETE_CONFIRMATION @"deleteConfirmation"

#define KEY_NOTIFICATION_BADGE @"notificationBadge"
#define KEY_NOTIFICATION_CALENDAR @"notificationCalendar"
#define KEY_NOTIFICATION_OVERDUE @"notificationOverdue"
#define KEY_NOTIFICATION_PROCESS @"notificationProcess"
#define KEY_NOTIFICATION_REVIEW @"notificationReview"

#define KEY_POSTPONE_TIME @"postponeTime"

@interface Settings ()

@property (assign, nonatomic) BOOL dontSave;
@end

@implementation Settings

- (void)save:(NSString *)key {
	if (self.dontSave)
		return;
	
	[super save:key];
}

- (void)setICloud:(BOOL)value {
	if (_iCloud == value)
		return;
	
	_iCloud = value;
	[self save];
}

- (void)setSounds:(BOOL)value {
	if (_sounds == value)
		return;
	
	_sounds = value;
	[self save];
}

- (void)setTheme:(NSUInteger)value {
	if (_theme == value)
		return;
	
	_theme = value;
	[self save];
}

- (void)setMultilineTitles:(BOOL)multipleLines {
	if (_multilineTitles == multipleLines)
		return;

	_multilineTitles = multipleLines;
	[self save];
}

- (void)setDeleteConfirmation:(BOOL)value {
	if (_deleteConfirmation == value)
		return;
	
	_deleteConfirmation = value;
	[self save];
}

- (void)setNotificationBadge:(BOOL)value {
	if (_notificationBadge == value)
		return;
	
	_notificationBadge = value;
	[self save];
}

- (void)setNotificationCalendar:(Notification *)reminderCalendar {
	if ([_notificationCalendar isEqualToReminderSettings:reminderCalendar])
		return;
	
	_notificationCalendar = reminderCalendar;
	[self save];
}

- (void)setNotificationOverdue:(Notification *)reminderOverdue {
	if ([_notificationOverdue isEqualToReminderSettings:reminderOverdue])
		return;
	
	_notificationOverdue = reminderOverdue;
	[self save];
}

- (void)setNotificationProcess:(Notification *)reminderProcess {
	if ([_notificationProcess isEqualToReminderSettings:reminderProcess])
		return;
	
	_notificationProcess = reminderProcess;
	[self save];
}

- (void)setNotificationReview:(Notification *)reminderReview {
	if ([_notificationReview isEqualToReminderSettings:reminderReview])
		return;
	
	_notificationReview = reminderReview;
	[self save];
}

- (void)setPostponeTime:(NSTimeInterval)postponeTime {
	if (_postponeTime == postponeTime)
		return;
	
	_postponeTime = postponeTime;
	[self save];
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	self.dontSave = YES;
	
	// remove
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([dictionary objectForKey:KEY_ICLOUD]) {
		self.iCloud = [dictionary boolForKey:KEY_ICLOUD];
		
		self.sounds = [dictionary boolForKey:KEY_SOUNDS];

		self.theme = [dictionary integerForKey:KEY_THEME];

		NSNumber *multilineTitles = [dictionary objectForKey:KEY_MULTILINE_TITLES];
		self.multilineTitles = multilineTitles ? [multilineTitles boolValue] : YES;
		
		self.deleteConfirmation = [dictionary boolForKey:KEY_DELETE_CONFIRMATION];
		
		self.notificationBadge = [dictionary boolForKey:KEY_NOTIFICATION_BADGE];
		self.notificationCalendar = [[Notification alloc] initFromDictionary:dictionary[KEY_NOTIFICATION_CALENDAR]];
		self.notificationOverdue = [[Notification alloc] initFromDictionary:dictionary[KEY_NOTIFICATION_OVERDUE]];
		self.notificationProcess = [[Notification alloc] initFromDictionary:dictionary[KEY_NOTIFICATION_PROCESS]];
		self.notificationReview = [[Notification alloc] initFromDictionary:dictionary[KEY_NOTIFICATION_REVIEW]];
		
		self.postponeTime = dictionary[KEY_POSTPONE_TIME] ? [dictionary doubleForKey:KEY_POSTPONE_TIME] : 10 * 60;
	
		self.dontSave = NO;
	} else if ([defaults objectForKey:KEY_ICLOUD]) {
		self.iCloud = [defaults boolForKey:KEY_ICLOUD];
		
		self.sounds = [defaults boolForKey:KEY_SOUNDS];
		
		self.theme = [defaults integerForKey:KEY_THEME];

		NSNumber *multilineTitles = [defaults objectForKey:KEY_MULTILINE_TITLES];
		self.multilineTitles = multilineTitles ? [multilineTitles boolValue] : YES;
		
		self.deleteConfirmation = [defaults boolForKey:KEY_DELETE_CONFIRMATION];
		
		self.notificationBadge = [defaults boolForKey:KEY_NOTIFICATION_BADGE];
		self.notificationCalendar = [[Notification alloc] initFromDictionary:[defaults dictionaryForKey:KEY_NOTIFICATION_CALENDAR]];
		self.notificationOverdue = [[Notification alloc] initFromDictionary:[defaults dictionaryForKey:KEY_NOTIFICATION_OVERDUE]];
		self.notificationProcess = [[Notification alloc] initFromDictionary:[defaults dictionaryForKey:KEY_NOTIFICATION_PROCESS]];
		self.notificationReview = [[Notification alloc] initFromDictionary:[defaults dictionaryForKey:KEY_NOTIFICATION_REVIEW]];
		
		self.postponeTime = [defaults objectForKey:KEY_POSTPONE_TIME] ? [defaults doubleForKey:KEY_POSTPONE_TIME] : 10 * 60;
		//
	} else {
		self.iCloud = [NSFileManager isUbiquityAvailable];
		
		self.sounds = YES;
		
		self.theme = 0;//[UIHelper hasBlackFrontPanel];

		self.multilineTitles = YES;
		
		self.deleteConfirmation = YES;
		
		self.notificationBadge = YES;
		self.notificationCalendar = [Notification create:YES :[Notification defaultSound: LOOP_JUST_AS_YOU_ARE_2] :9*60*60];
		self.notificationOverdue = [Notification create:YES :[Notification defaultSound:BEEP_GUITAR] :9*60*60];
		self.notificationProcess = [Notification create:YES :[Notification defaultSound:BEEP_PIANO] :17*60*60];
		self.notificationReview = [Notification create:YES :[Notification defaultSound:BEEP_XYLO] :17*60*60];
		
		self.postponeTime = 10 * 60;
		
		self.dontSave = NO;
		
		[self save];
	}
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	
	[dictionary setBool:self.iCloud forKey:KEY_ICLOUD];
	
	[dictionary setBool:self.sounds forKey:KEY_SOUNDS];
	
	[dictionary setInteger:self.theme forKey:KEY_THEME];

	[dictionary setBool:self.multilineTitles forKey:KEY_MULTILINE_TITLES];
	
	[dictionary setBool:self.deleteConfirmation forKey:KEY_DELETE_CONFIRMATION];
	
	[dictionary setBool:self.notificationBadge forKey:KEY_NOTIFICATION_BADGE];
	[dictionary setObject:[self.notificationCalendar toDictionary] forKey:KEY_NOTIFICATION_CALENDAR];
	[dictionary setObject:[self.notificationOverdue toDictionary] forKey:KEY_NOTIFICATION_OVERDUE];
	[dictionary setObject:[self.notificationProcess toDictionary] forKey:KEY_NOTIFICATION_PROCESS];
	[dictionary setObject:[self.notificationReview toDictionary] forKey:KEY_NOTIFICATION_REVIEW];
	
	[dictionary setDouble:self.postponeTime forKey:KEY_POSTPONE_TIME];
	
	return dictionary;
}

@end
