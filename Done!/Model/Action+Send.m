//
//  Action+Send.m
//  Done!
//
//  Created by Alexander Ivanov on 05.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action+Send.h"
#import "NSDateFormatter+Convenience.h"

#define KEY_UUID @"u"
#define KEY_TITLE @"t"
#define KEY_STATE @"s"
#define KEY_DATE @"d"
#define KEY_PERSON @"p"

@implementation Action (Send)

+ (Action *)importFromFile:(NSURL *)url {
	Action *action = [[Action alloc] init];
	
	[action loadFromFile:url];
	
	return action;
}

- (NSURL *)exportToFile {
	Action *action = [self clone:YES];
	
	NSURL *url = [Action urlFromKey:action.title extension:FILE_EXTENSION_TASK];
	
	[action saveToFile:url];
	
	return url;
}

+ (Action *)importFromDictionary:(NSDictionary *)dictionary {
	if (![dictionary[KEY_TITLE] length])
		return Nil;
	
	Action *instance = [[Action alloc] initFromDictionary:Nil];
	instance.uuid = dictionary[KEY_UUID];
	instance.title = dictionary[KEY_TITLE];
	instance.stateRaw = [dictionary[KEY_STATE] integerValue];
	instance.date = [[NSDateFormatter RFC3339Formatter] dateFromString:dictionary[KEY_DATE]];
	instance.personDescription = dictionary[KEY_PERSON];
	
	return instance;
}

- (NSDictionary *)exportToDictionary {
	NSMutableDictionary *dictionary = [NSMutableDictionary new];
	
	if (self.uuid.length)
		dictionary[KEY_UUID] = self.uuid;
	if (self.title.length)
		dictionary[KEY_TITLE] = self.title;
	if (self.stateRaw)
		dictionary[KEY_STATE] = @(self.stateRaw);

	if (self.stateRaw == GTD_ACTION_STATE_DEFERRAL || self.stateRaw == GTD_ACTION_STATE_CALENDAR) {
		if (self.date)
			dictionary[KEY_DATE] = [[NSDateFormatter RFC3339Formatter] stringFromDate:self.date];
	} else if (self.stateRaw == GTD_ACTION_STATE_DELEGATE) {
		if (self.personDescription.length)
			dictionary[KEY_PERSON] = self.personDescription;
	}
	
	return dictionary;
}

@end
