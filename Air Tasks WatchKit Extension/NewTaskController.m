//
//  NewTaskController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 01.04.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "Global.h"
#import "List.h"
#import "NewTaskController.h"

#import "NSArray+Query.h"
#import "NSDate+Calculation.h"
#import "NSDate+Description.h"
#import "NSDateDetector.h"
#import "NSDateFormatter+Convenience.h"
#import "NSHelper.h"
#import "UIImageCache.h"
#import "WCSessionDelegate.h"

@interface NewTaskController()
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *date;

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *group;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *textLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button;
@end

@implementation NewTaskController

- (void)setup {
	if (self.title.length) {
		[self.group setHidden:NO];
		[self.button setHidden:NO];
		
		[self.textLabel setText:self.title];
		
		if (self.date) {
			[self.detailTextLabel setText:[self.date descriptionForTime:NSDateFormatterShortStyle]];
			[self.image setImage:[IMG_CACHE originalImage:[self.date isPast] ? @"watch-calendar-past" : @"watch-calendar"]];
		} else {
			[self.detailTextLabel setText:@"in-basket"];
			[self.image setImage:Nil];
		}
	} else {
		[self.group setHidden:YES];
		[self.button setHidden:YES];
	}
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
	
	[self setup];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
	[super willActivate];
	
	[self dictation];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)add {
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	userInfo[EXT_ACTION_KEY] = EXT_ACTION_ADD_KEY;
	userInfo[EXT_TITLE_KEY] = self.title;
	if (self.date)
		userInfo[EXT_DATE_KEY] = [[NSDateFormatter RFC3339Formatter] stringFromValue:self.date];
	
	[[WCSessionDelegate instance].session sendMessage:userInfo replyHandler:^(NSDictionary *replyInfo) {
		NSArray *array = replyInfo[EXT_LIST_KEY];
		
		[GLOBAL setListFromArray:array];
		
		[self dismissController];
	}];
}

- (IBAction)dictation {
	[self presentTextInputControllerWithSuggestions:Nil allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
		NSString *title = [results first:^BOOL(id item) {
			return [item isKindOfClass:[NSString class]];
		}];
//		title = @"Meet Catherine at 8 PM";
		if (!title.length)
			return;
		
		NSDateDetector *detector = [[NSDateDetector alloc] initWithString:title];
		if (detector.date) {
			self.title = detector.string;
			self.date = detector.date;
		} else {
			self.title = title;
			self.date = Nil;
		}
		
		[self setup];
	}];
}

@end



