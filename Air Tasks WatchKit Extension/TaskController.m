//
//  TaskController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 31.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "DateHelper.h"
#import "Global.h"
#import "NotificationHelper.h"
#import "Task.h"
#import "TaskController.h"

#import "NSDate+Calculation.h"
#import "UIImageCache.h"
#import "UILocalNotification+Convenience.h"
#import "WCSessionDelegate.h"

@interface TaskController()
@property (strong, nonatomic) NSString *uuid;

@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *textLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *detailTextLabel;

@property (strong, nonatomic) NSArray *context;
@end

@implementation TaskController

- (void)setup:(Task *)task {
	self.uuid = task.uuid;
	
	[self.textLabel setAttributedText:[task attributedTitle:[UIFont systemFontOfSize:/*[UIFont systemFontSize]*/16.0]]];
	[self.detailTextLabel setText:task.dateDescription];
	[self.image setImage:[IMG_CACHE originalImage:task.state == GTD_ACTION_STATE_CALENDAR ? [task.date isPast] ? @"watch-calendar-past" : @"watch-calendar" : @"watch-deferral"]];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
	
	[self setup:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)complete {
	[[WCSessionDelegate instance].session sendMessage:@{ EXT_ACTION_KEY : GUI_NOTIFICATION_ACTION_COMPLETE, KEY_UUID : self.uuid } replyHandler:^(NSDictionary *replyInfo) {
		NSArray *array =  replyInfo[EXT_LIST_KEY];
		
		[GLOBAL setListFromArray:array];
		
		[self dismissController];
	}];
}

@end



