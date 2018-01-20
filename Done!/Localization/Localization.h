//
//  Localization.h
//  Done!
//
//  Created by Alexander Ivanov on 30.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localization : NSObject

+ (NSString *)ok;
+ (NSString *)done;
+ (NSString *)cancel;

+ (NSString *)later;

+ (NSString *)newAction;
+ (NSString *)deleteAction;
+ (NSString *)deleteFolder;
+ (NSString *)moveToInBasket;
+ (NSString *)undoAction;

+ (NSString *)date;
+ (NSString *)time;
+ (NSString *)alert;
+ (NSString *)atTheSameTime;
+ (NSString *)before:(NSString *)someTime;
+ (NSString *)postpone;
+ (NSString *)schedule;

+ (NSString *)yesterday;
+ (NSString *)today;
+ (NSString *)tomorrow;
+ (NSString *)lastWeek;
+ (NSString *)thisWeek;
+ (NSString *)nextWeek;
+ (NSString *)lastMonth;
+ (NSString *)thisMonth;
+ (NSString *)nextMonth;
+ (NSString *)lastYear;
+ (NSString *)thisYear;
+ (NSString *)nextYear;
+ (NSString *)someday;

+ (NSString *)deferralMessage;
+ (NSString *)calendar;

+ (NSString *)description;
+ (NSString *)disabled;
+ (NSString *)enabled;
+ (NSString *)sound;
+ (NSString *)try;
+ (NSString *)restore;

+ (NSString *)emptyFocus;
+ (NSString *)emptyFolder;

+ (NSString *)inBasket;
+ (NSString *)delegated;
+ (NSString *)completed;

+ (NSString *)allDone;

+ (NSString *)statisticsActionsInList;
+ (NSString *)statisticsActionsForToday;
+ (NSString *)statisticsActionsDoneTotal;
+ (NSString *)statisticsDaysPassedTotal;
+ (NSString *)statisticsActionsDonePerDay;

@end
