//
//  Settings.h
//  Done!
//
//  Created by Alexander Ivanov on 06.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSPropertyDictionary.h"
#import "Notification.h"

@interface Settings : NSPropertyDictionary

@property (nonatomic, assign) BOOL iCloud;

@property (nonatomic, assign) BOOL sounds;

@property (nonatomic, assign) NSUInteger theme;

@property (nonatomic, assign) BOOL multilineTitles;

@property (nonatomic, assign) BOOL deleteConfirmation;

@property (nonatomic, assign) BOOL notificationBadge;
@property (nonatomic, strong) Notification *notificationCalendar;
@property (nonatomic, strong) Notification *notificationOverdue;
@property (nonatomic, strong) Notification *notificationProcess;
@property (nonatomic, strong) Notification *notificationReview;
@property (nonatomic, assign) NSTimeInterval postponeTime;

@end
