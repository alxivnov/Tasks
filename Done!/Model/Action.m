//
//  Action.m
//  Done!
//
//  Created by Alexander Ivanov on 11.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "ABHelper.h"
#import "Action.h"
#import "NSHelper.h"
#import "NSDate+Calculation.h"

#define TITLE_KEY @"title"
#define STATE_KEY @"state"
#define PERSON_KEY @"person"
#define PERSON_NAME_KEY @"person_name"
#define DATE_KEY @"date"
#define DATE_TIMEZONE_KEY @"date_timezone"
#define DATE_INTERVAL_KEY @"date_interval"
#define TIME_INTERVAL_KEY @"time_interval"
#define SOUND_NAME_KEY @"sound_name"
#define REPEAT_INTERVAL_KEY @"repeat_interval"
#define REPEAT_REMINDER_KEY @"repeat_reminder"
#define ALERT_INTERVAL_KEY @"alert_interval"
#define FOLDER_KEY @"folder"
#define FOLDER_COUNT_KEY @"folder_count"
#define REPEAT_KEY @"repeat"
#define REPEAT_COUNT_KEY @"repeat_count"
#define LOGGER_COUNT_KEY @"logger_count"
#define UUID_KEY @"uuid"
#define CREATED_KEY @"created"
#define CHANGED_KEY @"changed"
#define DELETED_KEY @"deleted"

@interface Action ()
@property (strong, nonatomic) NSDate *baseDate;
@property (assign, nonatomic) NSInteger timeZone;
@end

@implementation Action

// instance

- (void)setTitle:(NSString *)value {
	if ([NSHelper string:_title isEqualTo:value])
		return;
	
	_title = value;
	_changed = [NSDate date];
}

- (GTD_ACTION_STATE)state {
	if (self.stateRaw & GTD_ACTION_STATE_DONE)
		return GTD_ACTION_STATE_DONE;
	else
		return self.stateRaw;
}

- (void)setState:(GTD_ACTION_STATE)value {
	if (self.stateRaw == value)
		return;
	
	if (value == GTD_ACTION_STATE_NULL && self.state == GTD_ACTION_STATE_DONE) {
		self.stateRaw &= GTD_ACTION_STATE_DEFERRAL | GTD_ACTION_STATE_CALENDAR | GTD_ACTION_STATE_DELEGATE;
		
		_deleted = Nil;
	} else if (value == GTD_ACTION_STATE_DONE) {
		self.stateRaw |= GTD_ACTION_STATE_DONE;
		
		_deleted = [NSDate date];
	} else {
		self.stateRaw = value;
	}
		
	_changed = [NSDate date];
}

- (void)setPerson:(NSInteger)value {
	if (_person == value)
		return;
	
	_person = value;
	_changed = [NSDate date];
}

- (void)setPersonDescription:(NSString *)value {
	if ([NSHelper string:_personDescription isEqualTo:value])
		return;
	
	_personDescription = value;
	_changed = [NSDate date];
}

- (NSDate *)date {
	if (self.state == GTD_ACTION_STATE_DONE || self.state == GTD_ACTION_STATE_NULL)
		return Nil;
	
	NSInteger timeZone = [_baseDate secondsFromGMT];
	
	return _timeZone == timeZone ? _baseDate : [_baseDate move:_timeZone - timeZone];
}

- (void)setDate:(NSDate *)dateTime {
	NSInteger timeZone = [dateTime secondsFromGMT];
	
	if ([NSHelper date:_baseDate isEqualTo:dateTime] && _timeZone == timeZone)
		return;
	
	_baseDate = dateTime;
	_timeZone = timeZone;
	
	_changed = [NSDate date];
}

- (NSDate *)dateRaw {
	return _baseDate;
}

- (void)setSoundName:(NSString *)soundName {
	if ([_soundName isEqualToString:soundName])
		return;
	
	_soundName = soundName;
	_changed = [NSDate date];
}

- (void)setRepeatInterval:(NSCalendarUnit)repeatInterval {
	if (_repeatInterval == repeatInterval)
		return;
	
	_repeatInterval = repeatInterval;
	_changed = [NSDate date];
}

- (void)setAlertInterval:(NSTimeInterval)alertInterval {
	if (_alertInterval == alertInterval)
		return;
	
	_alertInterval = alertInterval;
	_changed = [NSDate date];
}

- (BOOL)folder {
	return _folderValues && [_folderValues count] > 0;
}

@synthesize folderValues = _folderValues;

- (Basket *)folderValues {
	if (!_folderValues)
		_folderValues = [[Basket alloc] initWithParent:self];
	
	return _folderValues;
}

- (void)setFolderValues:(Basket *)folder {
	if (_folderValues == folder)
		return;
	
	_folderValues = folder;
	_changed = [NSDate date];
}

- (void)setFolderCount:(NSUInteger)folderCount {
	if (_folderCount == folderCount)
		return;
	
	_folderCount = folderCount;
	_changed = [NSDate date];
}

- (BOOL)repeat {
	return self.repeatValues && [self.repeatValues count] > 0;
}

- (void)setRepeatValues:(NSArray *)repeat {
	if (_repeatValues == repeat)
		return;
	
	_repeatValues = repeat;
	_changed = [NSDate date];
}

- (void)setRepeatCount:(NSUInteger)repeatCount {
	if (_repeatCount == repeatCount)
		return;
	
	_repeatCount = repeatCount;
	_changed = [NSDate date];
}

- (void)setLoggerCount:(NSUInteger)loggerCount {
	if (_loggerCount == loggerCount)
		return;
	
	_loggerCount = loggerCount;
	_changed = [NSDate date];
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	if (dictionary) {
		_title = dictionary[TITLE_KEY];
		_stateRaw = [(NSNumber *)dictionary[STATE_KEY] unsignedIntegerValue];
		
		if (_stateRaw & (GTD_ACTION_STATE_DEFERRAL | GTD_ACTION_STATE_CALENDAR)) {
			NSDate *baseDate = dictionary[DATE_KEY];
			NSNumber *tz = dictionary[DATE_TIMEZONE_KEY];
			if (tz) {
				_baseDate = baseDate;
				_timeZone = [tz integerValue];
			} else {
				_baseDate = (_stateRaw & GTD_ACTION_STATE_CALENDAR) || dictionary[TIME_INTERVAL_KEY] ? baseDate : [baseDate move:9*TIME_HOUR];
				_timeZone = [_baseDate secondsFromGMT];
			}
			
			if (_stateRaw & GTD_ACTION_STATE_CALENDAR) {
				_soundName = dictionary[SOUND_NAME_KEY];
				
				NSNumber *ri = dictionary[REPEAT_INTERVAL_KEY];
				if (!ri)
					ri = dictionary[REPEAT_REMINDER_KEY];
				_repeatInterval = [ri unsignedIntegerValue];
				
				_alertInterval = [dictionary[ALERT_INTERVAL_KEY] doubleValue];
			}
		} else if (_stateRaw & GTD_ACTION_STATE_DELEGATE) {
			_person = [(NSNumber *)dictionary[PERSON_KEY] integerValue];
			_personDescription = [ABHelper getCompositeNameByRecordID:_person];
			if (!_personDescription)
				_personDescription = dictionary[PERSON_NAME_KEY];
		}
		
		__strong NSArray *folderArray = dictionary[FOLDER_KEY];
		if (folderArray) {
			_folderValues = [[Basket alloc] initWithParent:self];
			
			[_folderValues loadFromArray:folderArray];
		}
		_folderCount = [(NSNumber *)dictionary[FOLDER_COUNT_KEY] unsignedIntegerValue];
		
		_repeatValues = dictionary[REPEAT_KEY];
		_repeatCount = [(NSNumber *)dictionary[REPEAT_COUNT_KEY] unsignedIntegerValue];
		
		_loggerCount = [(NSNumber *)dictionary[LOGGER_COUNT_KEY] unsignedIntegerValue];
		
		_uuid = dictionary[UUID_KEY];
		_created = dictionary[CREATED_KEY];
		_changed = dictionary[CHANGED_KEY];
		_deleted = dictionary[DELETED_KEY];
	} else {
		_uuid = [NSUUID UUID].UUIDString;
		_created = [NSDate date];
	}
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	if (self.title.length)
		dictionary[TITLE_KEY] = self.title;
	if (self.stateRaw)
		dictionary[STATE_KEY] = @(self.stateRaw);
	
	if (self.stateRaw & (GTD_ACTION_STATE_DEFERRAL | GTD_ACTION_STATE_CALENDAR)) {
		if (self.baseDate)
			dictionary[DATE_KEY] = self.baseDate;
		dictionary[DATE_TIMEZONE_KEY] = @(self.timeZone);
		
		if (self.stateRaw & GTD_ACTION_STATE_CALENDAR) {
			if (self.soundName)
				dictionary[SOUND_NAME_KEY] = self.soundName;
			if (self.repeatInterval)
				dictionary[REPEAT_INTERVAL_KEY] = @(self.repeatInterval);
			if (self.alertInterval)
				dictionary[ALERT_INTERVAL_KEY] = @(self.alertInterval);
		}
	} else if (self.stateRaw & GTD_ACTION_STATE_DELEGATE) {
		if (self.person)
			dictionary[PERSON_KEY] = @(self.person);
		if (self.personDescription.length)
			dictionary[PERSON_NAME_KEY] = self.personDescription;
	}
	
	if (self.folder)
		dictionary[FOLDER_KEY] = [self.folderValues saveToArray];
	if (self.folderCount)
		dictionary[FOLDER_COUNT_KEY] = @(self.folderCount);
	
	if (self.repeat)
		dictionary[REPEAT_KEY] = self.repeatValues;
	if (self.repeatCount)
		dictionary[REPEAT_COUNT_KEY] = @(self.repeatCount);
	
	if (self.loggerCount)
		dictionary[LOGGER_COUNT_KEY] = @(self.loggerCount);

	if (self.uuid.length)
		dictionary[UUID_KEY] = self.uuid;
	if (self.created != Nil)
		dictionary[CREATED_KEY] = self.created;
	if (self.changed != Nil)
		dictionary[CHANGED_KEY] = self.changed;
	if (self.deleted != Nil)
		dictionary[DELETED_KEY] = self.deleted;
	
	return dictionary;
}

- (void)clone:(Action *)action deep:(BOOL)deep {
	self.title = action.title;
	self.stateRaw = action.stateRaw;
	
	self.baseDate = action.baseDate;
	self.timeZone = action.timeZone;
	
	self.soundName = action.soundName;
	self.repeatInterval = action.repeatInterval;
	self.alertInterval = action.alertInterval;
	
	self.person = action.person;
	self.personDescription = action.personDescription;
	
	if (deep)
		self.folderValues = [action.folderValues clone:self];
	self.folderCount = action.folderCount;
	
	self.repeatValues = action.repeatValues;
	self.repeatCount = action.repeatCount;
	
	self.loggerCount = action.loggerCount;
	
	self.uuid = action.uuid;
	self.created = action.created;
	self.changed = action.changed;
	self.deleted = action.deleted;
}

- (instancetype)clone:(BOOL)deep {
	Action *instance = [[[self class] alloc] init];
	
	[instance clone:self deep:deep];
	
	return instance;
}

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"%@ (%@, %@)", self.title, @(self.state), self.date];
}

- (NSString *)key {
	return self.uuid;
}

- (void)load:(NSString *)key {
	[super load:key];
	
	self.updated = self.changed;
}

- (void)save:(NSString *)key {
	[super save:key];
	
	self.updated = self.changed;
}

- (BOOL)isChanged {
	return ![NSHelper date:self.changed isEqualTo:self.updated] || self.parent.mode != DISTRIBUTED_LAZY;
}

- (id <NSPropertyDataSource>)dataSource {
	return self.parent ? self.parent.dataSource : [super dataSource];
}

@end
