//
//  TableRowController.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 31.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "DateHelper.h"
#import "NSDate+Calculation.h"
#import "TaskRowController.h"
#import "UIImageCache.h"

@interface TaskRowController ()
@property (weak, nonatomic) IBOutlet WKInterfaceImage *image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *textLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *detailTextLabel;
@end

@implementation TaskRowController

- (void)setup:(Task *)task {
	[self.textLabel setAttributedText:[task attributedTitle:[UIFont systemFontOfSize:/*[UIFont systemFontSize]*/16.0]]];
	[self.detailTextLabel setText:task.dateDescription];
	[self.image setImage:[IMG_CACHE originalImage:task.state == GTD_ACTION_STATE_CALENDAR ? [task.date isPast] ? @"watch-calendar-past" : @"watch-calendar" : @"watch-deferral"]];
}

@end
