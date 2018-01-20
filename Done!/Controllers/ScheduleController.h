//
//  CalendarController.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 07.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+Popover.h"

@interface ScheduleController : UITableViewController

@property (copy, nonatomic) void(^completion)(ScheduleController *sender, BOOL success);

+ (NSDate *)getDate:(UIViewController *)controller;
+ (BOOL)getRepeat:(UIViewController *)controller;
+ (NSString *)getSound:(UIViewController *)controller;
+ (NSTimeInterval)getAlert:(UIViewController *)controller;

+ (void)setDate:(NSDate *)date repeat:(BOOL)repeat sound:(NSString *)sound alert:(NSTimeInterval)alert forViewController:(UIViewController *)controller;

@end
