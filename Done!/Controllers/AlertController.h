//
//  AlertController.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 16.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertController : UITableViewController

+ (NSString *)alertDisplayName:(NSTimeInterval)ti;

+ (NSTimeInterval)getAlert:(UIViewController *)controller;
+ (void)setAlert:(NSTimeInterval)alert andChanged:(void(^)(NSTimeInterval alert))changed forViewController:(UIViewController *)controller;

@end
