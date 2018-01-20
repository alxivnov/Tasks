//
//  ReminderSettings.m
//  Done!
//
//  Created by Alexander Ivanov on 25.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Notification.h"
#import "Sounds.h"

#define ON_KEY @"on"
#define TIME_KEY @"time"
#define SOUND_KEY @"sound"

@interface Notification ()
@property (assign, nonatomic, readwrite) BOOL on;
@property (strong, nonatomic, readwrite) NSString *sound;
@property (assign, nonatomic, readwrite) NSTimeInterval time;
@end

@implementation Notification

static NSString *_defaultSound;

+ (NSString *)defaultSound:(NSString *)sound {
	if (!_defaultSound)
		_defaultSound = [NSString stringWithFormat:@"%@.%@", sound ? sound : BEEP_XYLO, AIFF];
	
	return _defaultSound;
}

- (void)fromDictionary:(NSDictionary *)dictionary {
	self.on = [((NSNumber *)dictionary[ON_KEY]) boolValue];
	self.sound = dictionary[SOUND_KEY];
	self.time = [((NSNumber *)dictionary[TIME_KEY]) doubleValue];
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	dictionary[ON_KEY] = @(self.on);
	dictionary[SOUND_KEY] = self.sound ? self.sound : [[self class] defaultSound:Nil];
	dictionary[TIME_KEY] = @(self.time);
	
	return dictionary;
}

- (BOOL)isEqualToReminderSettings:(Notification *)reminderSettings {
	return self.on == reminderSettings.on && [self.sound isEqualToString:reminderSettings.sound] && self.time == reminderSettings.time;
}

+ (instancetype)create:(BOOL)on :(NSString *)sound :(NSTimeInterval)time {
	Notification *reminderSettings = [[Notification alloc] init];
	reminderSettings.on = on;
	reminderSettings.sound = sound;
	reminderSettings.time = time;
	return reminderSettings;
}

@end
