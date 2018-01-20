//
//  Task.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 04.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSAttributedString+Mutable.h"
#import "NSDate+Calculation.h"
#import "NSHelper.h"
#import "Task.h"
#import "UIFont+Modification.h"

#define KEY_TITLE @"title"
#define KEY_TITLE_LENGTH @"titleLength"
#define KEY_STATE @"state"
#define KEY_BASE_DATE @"baseDate"
#define KEY_TIME_ZONE @"timeZone"
#define KEY_DATE @"date"
#define KEY_DATE_DESCRIPTION @"dateDescription"
#define KEY_UUID @"uuid"

@interface Task ()
@property (strong, nonatomic) NSDate *baseDate;
@property (assign, nonatomic) NSInteger timeZone;
@end

@implementation Task

- (NSDate *)date {
	NSInteger timeZone = [_baseDate secondsFromGMT];
	
	return _timeZone == timeZone ? _baseDate : [_baseDate move:_timeZone - timeZone];
}

- (void)setDate:(NSDate *)dateTime {
	NSInteger timeZone = [dateTime secondsFromGMT];
	
	if ([NSHelper date:_baseDate isEqualTo:dateTime] && _timeZone == timeZone)
		return;
	
	_baseDate = dateTime;
	_timeZone = timeZone;
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	if (dictionary) {
		_title = dictionary[KEY_TITLE];
		
		_titleLength = [dictionary[KEY_TITLE_LENGTH] unsignedIntegerValue];
		
		_state = [(NSNumber *)dictionary[KEY_STATE] unsignedIntegerValue];

		_baseDate = dictionary[KEY_BASE_DATE];
		_timeZone = [dictionary[KEY_TIME_ZONE] integerValue];
		
		_dateDescription = dictionary[KEY_DATE_DESCRIPTION];
		
		_uuid = dictionary[KEY_UUID];
	}
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	if (self.title)
		dictionary[KEY_TITLE] = self.title;
	
	if (self.titleLength)
		dictionary[KEY_TITLE_LENGTH] = @(self.titleLength);
	
	if (self.state)
		dictionary[KEY_STATE] = @(self.state);
	
	if (self.baseDate) {
		dictionary[KEY_BASE_DATE] = self.baseDate;
		dictionary[KEY_TIME_ZONE] = @(self.timeZone);
	}

	if (self.dateDescription)
		dictionary[KEY_DATE_DESCRIPTION] = self.dateDescription;
	
	if (self.uuid)
		dictionary[KEY_UUID] = self.uuid;
	
	return dictionary;
}

- (NSAttributedString *)attributedTitle:(UIFont *)font {
	NSAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.title];
	if (self.titleLength) {
		NSRange range = NSMakeRange(0, self.titleLength);
		if (self.titleLength < [self.title length])
			[title underline:range];
		title = [title font:[font bold] forRange:range];
	}
	return title;
}

@end
