//
//  WatchDelegate.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 02.10.15.
//  Copyright © 2015 Alex Ivanov. All rights reserved.
//

#import "WatchDelegate.h"
#import "AlertHelper.h"
#import "Basket+Query.h"
#import "Basket+Tasks.h"
#import "EditableBasket+Calendar.h"
#import "InBasketController.h"
#import "List.h"
#import "Localization.h"
#import "NotificationHelper.h"
#import "Workflow.h"

#import "NSDateFormatter+Convenience.h"
#import "NSHelper.h"
#import "UIApplication+Background.h"
#import "UIApplication+Notification.h"
#import "UIApplication+ViewController.h"

@implementation WatchDelegate

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
//	[[UIApplication sharedApplication] performBackgroundTask:^{
		NSString *action = message[EXT_ACTION_KEY];
		if ([action isEqualToString:EXT_ACTION_STATISTICS_KEY]) {
			NSUInteger count = [[Workflow instance].basket rangeWhereDateIsEqualTo:[AlertHelper today]].length;
			NSDictionary *replyInfo = @{ EXT_NUMBER_KEY : @(count), EXT_STRING_KEY : count ? [Localization statisticsActionsForToday] : [Localization allDone] };
			replyHandler(replyInfo ? replyInfo : @{ });
		} else if (!action.length) {
			NSArray *array = [[[Workflow instance].basket tasks:[AlertHelper today]] saveToArray];
			NSDictionary *replyInfo = @{ EXT_LIST_KEY : array, EXT_STRING_KEY : [[Localization today] uppercaseString] };
			replyHandler(replyInfo ? replyInfo : @{ });
		} else {
			[NSHelper dispatchToMain:^{
				if ([action isEqualToString:GUI_NOTIFICATION_ACTION_COMPLETE])
					[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) didReceiveNotification:message[KEY_UUID] withAction:GUI_NOTIFICATION_ACTION_COMPLETE];
				else if ([action isEqualToString:EXT_ACTION_ADD_KEY])
					[AS(InBasketController, [[UIApplication sharedApplication] rootViewController]) addAndCalendar:Nil title:message[EXT_TITLE_KEY] date:[[NSDateFormatter RFC3339Formatter] dateFromValue:message[EXT_DATE_KEY]]];

				NSArray *array = [[[Workflow instance].basket tasks:[AlertHelper today]] saveToArray];
				NSDictionary *replyInfo = @{ EXT_LIST_KEY : array, EXT_STRING_KEY : [[Localization today] uppercaseString] };
				replyHandler(replyInfo ? replyInfo : @{ });
			}];
		}
//	} expirationHandler:^{
//		replyHandler(@{ });
//	}];
}

@end
