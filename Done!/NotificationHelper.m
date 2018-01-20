//
//  NotificationHelper.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 01.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "LocalizationAlert.h"
#import "NotificationHelper.h"

#import "UIApplication+Notification.h"
#import "UIUserNotificationAction+Convenience.h"
#import "UIUserNotificationCategory+Convenience.h"
#import "UIHelper.h"

@implementation NotificationHelper

+ (void)request {
	if (!IOS_8_0)
		return;

	[UIApplication registerUserNotificationSettingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:@[ [UIUserNotificationCategory categoryWithIdentifier:GUI_NOTIFICATION_CATEGORY_CALENDAR defaultActions:@[ [UIUserNotificationAction actionWithIdentifier:GUI_NOTIFICATION_ACTION_COMPLETE title:[LocalizationAlert actionComplete] background:YES], [UIUserNotificationAction actionWithIdentifier:GUI_NOTIFICATION_ACTION_POSTPONE title:[LocalizationAlert actionPostpone] background:YES] ]] ]];
}

@end
