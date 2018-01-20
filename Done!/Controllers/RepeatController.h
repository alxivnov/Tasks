//
//  RepeatController.h
//  Done!
//
//  Created by Alexander Ivanov on 13.02.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKInAppPurchase.h"
#import "UIViewController+Popover.h"

@interface RepeatController : UITableViewController <UIPopoverContentDelegate>

+ (NSArray *)getValues:(UIViewController *)controller;
+ (void)setValues:(NSArray *)values andCount:(NSUInteger)count forViewController:(UIViewController *)controller;

@end
