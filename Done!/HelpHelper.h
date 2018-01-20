//
//  HelpHelper.h
//  Done!
//
//  Created by Alexander Ivanov on 19.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpHelper : NSObject <UIAlertViewDelegate>

+ (NSURL *)guideApplication;
+ (NSURL *)guidePurchaseRepeat;
+ (NSURL *)guidePurchaseFolder;
+ (NSURL *)guidePurchaseLogger;

+ (void)help:(UIViewController *)controller;

@end
