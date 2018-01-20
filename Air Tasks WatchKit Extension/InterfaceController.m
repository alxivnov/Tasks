//
//  InterfaceController.m
//  Air Tasks WatchKit Extension
//
//  Created by Alexander Ivanov on 28.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Global.h"
#import "InterfaceController.h"
#import "TaskRowController.h"
#import "Task.h"

#import "NSError+Log.h"
#import "WCSessionDelegate.h"
#import "WKInterfaceTable+Rows.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@end


@implementation InterfaceController

- (void)setup:(NSString *)title {
	if (title.length)
		[self setTitle:title];
	
	if (!GLOBAL.list)
		return;
	
	[self.table setRows:@{ @"newTask" : @(1), @"task" : @(GLOBAL.list.array.count) }];
	
	for (NSUInteger index = 0; index < GLOBAL.list.array.count; index++) {
		TaskRowController *row = [self.table rowControllerAtIndex:index + 1];
		
		Task *task = GLOBAL.list.array[index];
		
		[row setup:task];
	}
}

- (void)setupList:(NSDictionary *)dictionary {
	NSArray *array = dictionary[EXT_LIST_KEY];
	NSString *title = dictionary[EXT_STRING_KEY];

	[GLOBAL setListFromArray:array];

	[self setup:title];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
	
	[[WCSessionDelegate instance].session sendMessage:@{ } replyHandler:^(NSDictionary *replyInfo) {
		[self setupList:replyInfo];
	}];

	[WCSessionDelegate instance].didReceiveMessage = ^(NSDictionary<NSString *,id> *message, void (^replyHandler)(NSDictionary<NSString *,id> *replyMessage)) {
		[self setupList:message];
	};
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
	[super willActivate];
	
	[self setup:Nil];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
	return [segueIdentifier isEqualToString:@"task"] ? GLOBAL.list.array[rowIndex - 1] : Nil;
}

@end



