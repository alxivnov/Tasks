//
//  ReminderSettings.h
//  Done!
//
//  Created by Alexander Ivanov on 25.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSPropertyDictionary.h"

@interface Notification : NSPropertyDictionary

@property (assign, nonatomic, readonly) BOOL on;
@property (strong, nonatomic, readonly) NSString *sound;
@property (assign, nonatomic, readonly) NSTimeInterval time;

- (BOOL)isEqualToReminderSettings:(Notification *)reminderSettings;

+ (instancetype)create:(BOOL)on :(NSString *)sound :(NSTimeInterval)time;

+ (NSString *)defaultSound:(NSString *)sound;

@end
