//
//  SocialStatistics.m
//  Done!
//
//  Created by Alexander Ivanov on 22.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "SocialStatistics.h"
#import "NSObject+Cast.h"

#define COMPOSE_DATE_KEY @"composeDate"
#define COMPOSE_KEY @"compose"

#define APP_STORE_KEY @"appStore"

#define HAPPY_KEY @"happy"
#define CONFUSED_KEY @"confused"
#define UNHAPPY_KEY @"unhappy"

#define CANCEL_KEY @"cancel"

@implementation SocialStatistics

- (void)setCompose:(NSDate *)compose {
	if ([_compose isEqualToDate:compose])
		return;
	
	_compose = compose;
	[self save];
}

- (void)setAppStore:(NSDate *)appStore {
	if ([_appStore isEqualToDate:appStore])
		return;
	
	_appStore = appStore;
	[self save];
}

- (void)setHappy:(NSUInteger)happy {
	if (_happy == happy)
		return;
	
	_happy = happy;
	[self save];
}

- (void)setConfused:(NSUInteger)confused {
	if (_confused == confused)
		return;
	
	_confused = confused;
	[self save];
}

- (void)setUnhappy:(NSUInteger)unhappy {
	if (_unhappy == unhappy)
		return;
	
	_unhappy = unhappy;
	[self save];
}

- (void)setCancel:(NSUInteger)cancel {
	if (_cancel == cancel)
		return;
	
	_cancel = cancel;
	[self save];
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	[super fromDictionary:dictionary];
	
	if (!dictionary)
		return;
	
	self.compose = dictionary[COMPOSE_KEY];
	if (!self.compose)
		self.compose = dictionary[COMPOSE_DATE_KEY];
	
	self.appStore = dictionary[APP_STORE_KEY];
	
	self.happy = [((NSNumber *)dictionary[HAPPY_KEY]) unsignedIntegerValue];
	self.confused = [((NSNumber *)dictionary[CONFUSED_KEY]) unsignedIntegerValue];
	self.unhappy = [((NSNumber *)dictionary[UNHAPPY_KEY]) unsignedIntegerValue];
	
	self.cancel = [((NSNumber *)dictionary[CANCEL_KEY]) unsignedIntegerValue];
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[super toDictionary] as:[NSMutableDictionary class]];
	
	if (self.compose)
		dictionary[COMPOSE_KEY] = self.compose;
	
	if (self.appStore)
		dictionary[APP_STORE_KEY] = self.appStore;
	
	dictionary[HAPPY_KEY] = @(self.happy);
	dictionary[CONFUSED_KEY] = @(self.confused);
	dictionary[UNHAPPY_KEY] = @(self.unhappy);
	
	dictionary[CANCEL_KEY] = @(self.cancel);
	
	return dictionary;
}

@end
