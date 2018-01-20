//
//  NotificationHelper.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 01.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#define GUI_NOTIFICATION_ACTION_POSTPONE @"postpone"
#define GUI_NOTIFICATION_ACTION_COMPLETE @"complete"
#define GUI_NOTIFICATION_ACTION_QUESTION @"question"

#define GUI_NOTIFICATION_CATEGORY_CALENDAR @"reminder"

@interface NotificationHelper : NSObject

+ (void)request;

@end
