//
//  Deferred.h
//  Done!
//
//  Created by Alexander Ivanov on 13.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATE_TODAY 1
#define DATE_TOMOROW 2
#define DATE_YESTERDAY -2
#define DATE_THIS_WEEK 10
#define DATE_NEXT_WEEK 20
#define DATE_LAST_WEEK -20
#define DATE_THIS_MONTH 100
#define DATE_NEXT_MONTH 200
#define DATE_LAST_MONTH -200
#define DATE_THIS_YEAR 1000
#define DATE_NEXT_YEAR 2000
#define DATE_LAST_YEAR -2000

@interface DateHelper : NSObject

+ (NSString *)dayCountDescription:(NSUInteger)count;

+ (NSInteger)dateIdentifier:(NSDate *)date;
+ (NSString *)dateDescription:(NSDate *)date;

+ (NSArray *)deferralDates;

@end
