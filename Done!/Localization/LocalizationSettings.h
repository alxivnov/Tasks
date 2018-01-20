//
//  LocalizationSettings.h
//  Done!
//
//  Created by Alexander Ivanov on 29.07.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationSettings : NSObject

+ (NSString *)version;
+ (NSString *)feedback;
+ (NSString *)sounds;
+ (NSString *)theme;
+ (NSString *)theme:(NSUInteger)theme;
+ (NSString *)multilineTitles;
+ (NSString *)deleteConfirmation;
+ (NSString *)iconBadge;
+ (NSString *)calendarReminder;
+ (NSString *)overdueReminder;
+ (NSString *)processReminder;
+ (NSString *)reviewReminder;
+ (NSString *)postpone;
+ (NSString *)restorePurchases;
+ (NSString *)sendStatistics;

+ (NSString *)migrationTitle;
+ (NSString *)migrationMessage;

@end
