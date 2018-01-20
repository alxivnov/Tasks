//
//  TaskPageController.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 17.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIPopoverController+Convenience.h"

@interface CalendarController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIPopoverContentDelegate>

+ (void)setDate:(NSDate *)date repeat:(BOOL)repeat sound:(NSString *)sound alert:(NSTimeInterval)alert person:(NSInteger)person name:(NSString *)name index:(NSUInteger)index forViewController:(UIViewController *)controller;

@end
