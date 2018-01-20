//
//  AlertHelper.h
//  Done!
//
//  Created by Alexander Ivanov on 25.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "Action.h"

#define ALERT_BADGE @"badge"

#define ALERT_OVERDUE @"alert_overdue"
#define ALERT_PROCESS @"alert_process"
#define ALERT_REVIEW @"alert_review"

@interface AlertHelper : NSObject

+ (NSDate *)today;
+ (NSDate *)tomorrow;
+ (NSDate *)overdueDate;
+ (NSDate *)processDate;

+ (void)significantTimeChange;

+ (void)setOverdueDate:(NSDate *)date;
+ (void)setProcessDate:(NSDate *)date;

+ (void)scheduleCalendarAlert:(Action *)action calendarTime:(NSTimeInterval)calendarTime;

+ (void)didReceiveLocalNotificationWithUUID:(NSString *)uuid;

@end
