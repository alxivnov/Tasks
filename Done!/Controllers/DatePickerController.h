//
//  DatePickerController.h
//  Done!
//
//  Created by Alexander Ivanov on 13.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Notification.h"
#import "UIPopoverController+Convenience.h"

@interface DatePickerController : UIViewController <UIPopoverContentDelegate, UITableViewDataSource, UITableViewDelegate>

+ (NSDate *)getDate:(UIViewController *)controller;
+ (BOOL)getRepeat:(UIViewController *)controller;
+ (NSString *)getSound:(UIViewController *)controller;
+ (void)setDate:(NSDate *)values repeat:(BOOL)repeat andSound:(NSString *)sound forViewController:(UIViewController *)controller;

+ (BOOL)getNotificationVisible:(UIViewController *)controller;
+ (void)setNotificationVisible:(BOOL)visible forViewController:(UIViewController *)controller;
+ (void)setNavigationTitle:(NSString *)title forViewController:(UIViewController *)controller;

+ (Notification *)getNotification:(UIViewController *)controller;
+ (void)setNotification:(Notification *)notification forViewController:(UIViewController *)controller;

+ (void)setTime:(NSTimeInterval)time forViewController:(UIViewController *)controller;

@end
