//
//  PostponeController.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 17.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostponeController : UITableViewController

+ (NSDate *)getDate:(UIViewController *)controller;

@property (copy, nonatomic) void(^completion)(PostponeController *sender, BOOL success);

@end
