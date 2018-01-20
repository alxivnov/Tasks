//
//  ReminderController.h
//  Done!
//
//  Created by Alexander Ivanov on 13.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundsController : UITableViewController

+ (NSString *)soundDisplayName:(NSString *)path;

+ (NSString *)getSound:(UIViewController *)controller;
+ (void)setSound:(NSString *)sound andChanged:(void(^)(NSString *sound))changed forViewController:(UIViewController *)controller;

@end
